class Export < ApplicationRecord
  belongs_to :snap_application
  validates :status, inclusion: { in: %i(new queued in_process succeeded failed
                                         unnecessary) }
  validates :destination, inclusion: { in: %i(fax email sms) }

  attribute :destination, :symbol
  attribute :status, :symbol

  default_scope { order(updated_at: :desc) }
  scope :faxed, -> { where(destination: :fax) }
  scope :emailed, -> { where(destination: :email) }
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
      update(metadata: "Another export for this destination and app occurred",
             completed_at: Time.zone.now)
      return
    end

    transition_to new_status: :in_process
    yield(snap_application, logger)
    update(metadata: read_logger, completed_at: Time.zone.now)
    transition_to new_status: :succeeded
  rescue => e
    metadata = "#{e.class} - #{e.message} #{e.backtrace.join("\n")}"
    metadata += "\r\r\r#{read_logger}"
    update(metadata: metadata,
           completed_at: Time.zone.now)
    transition_to new_status: :failed
    raise e
  ensure
    snap_application.pdf.try(:close)
    snap_application.pdf.try(:unlink)
  end

  def logger
    return @_logger if @_logger.present?

    logger = ActiveSupport::Logger.new(logger_output)
    logger.level = Logger::DEBUG
    logger.formatter = Rails.application.config.log_formatter
    @_logger = ActiveSupport::TaggedLogging.new(logger)
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
