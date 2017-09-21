class Export < ApplicationRecord
  VALID_STATUS = %i(
    new
    queued
    in_process
    succeeded
    failed
    unnecessary
  ).freeze

  VALID_DESTINATIONS = %i(
    client_email
    office_email
    fax
    sms
    mi_bridges
  ).freeze

  belongs_to :snap_application
  validates :status, inclusion: { in: VALID_STATUS }
  validates :destination, inclusion: { in: VALID_DESTINATIONS }

  attribute :destination, :symbol
  attribute :status, :symbol

  default_scope { order(updated_at: :desc) }
  scope :faxed, -> { where(destination: :fax) }
  scope :emailed_client, -> { where(destination: :client_email) }
  scope :emailed_office, -> { where(destination: :office_email) }
  scope :succeeded, -> { where(status: :succeeded) }
  scope :for_destination, ->(destination) { where(destination: destination) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :application_ids, -> { pluck(:snap_application_id) }
  scope :latest, -> { first }
  scope :without, ->(export) { where.not(id: export.id) }
  scope :successful_or_in_flight, -> {
    where(status: %i(new queued in_process
                     succeeded))
  }

  def execute
    raise ArgumentError, "#export requires a block" unless block_given?

    if snap_application.exports.for_destination(destination).
        successful_or_in_flight.without(self).present? && !force

      transition_to new_status: :unnecessary
      update(metadata: "There is already another successful or in progress " \
                       "export for application #{snap_application_id} via " \
                       "#{destination}. If you really want to re-export " \
                       "use the force flag",
             completed_at: Time.zone.now)
      return
    end

    transition_to new_status: :in_process
    yield(snap_application, logger)
    update(metadata: read_logger, completed_at: Time.zone.now)
    transition_to new_status: :succeeded
  rescue StandardError => e
    fail_with_exception(e)
    raise e
  ensure
    begin
      snap_application.close_pdf
    rescue StandardError => e
      fail_with_exception(e)
    end
  end

  def fail_with_exception(e)
    metadata = "#{read_logger}\n#{'*' * 20}\n#{'*' * 20}\n"
    metadata += "#{e.class} - #{e.message} #{e.backtrace.join("\n")}"
    update(metadata: metadata,
           completed_at: Time.zone.now)
    transition_to new_status: :failed
  end

  def logger
    return @_logger if @_logger.present?

    @_logger = LoggerFactory.create(
      level: Logger::DEBUG,
      output: logger_output,
    )
  end

  def logger_output
    @_logger_output ||= StringIO.new
  end

  def read_logger
    logger_output.rewind
    logger_output.read
  end

  def transition_to(new_status:)
    update!(status: new_status)
  end

  def succeeded?
    status == :succeeded
  end
end
