class Export < ApplicationRecord
  DELAY_THRESHOLD = 30
  class UnknownExportTypeError < StandardError; end

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

  def self.create_and_enqueue(params)
    Enqueuer.new.create_and_enqueue_export(params)
  end

  def self.create_and_enqueue!(params)
    Enqueuer.new.create_and_enqueue_export!(params)
  end

  def self.enqueue_faxes
    Enqueuer.new.enqueue_faxes
  end

  def execute
    raise ArgumentError, "#export requires a block" unless block_given?

    if snap_application.exports.succeeded.
        for_destination(destination).present? && !force

      transition_to new_status: :failed
      update(metadata: "Didn't run since a previous export succeeded",
             completed_at: Time.zone.now)
      return
    end

    transition_to new_status: :in_process
    result = yield(snap_application, logger)
    update(metadata: result + read_logger, completed_at: Time.zone.now)
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

    logger = ActiveSupport::Logger.new(STDOUT)
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
