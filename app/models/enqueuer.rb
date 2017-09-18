class Enqueuer
  DELAY_THRESHOLD = 30

  def self.create_and_enqueue_export(params)
    new.create_and_enqueue_export(params)
  end

  def self.create_and_enqueue_export!(params)
    new.create_and_enqueue_export!(params)
  end

  def enqueue_faxes
    SnapApplication.
      faxable.
      untouched_since(DELAY_THRESHOLD.minutes.ago).
      find_each do |snap_application|
        create_and_enqueue_export(
          destination: :fax,
          snap_application: snap_application,
        )
      end
  end

  def create_and_enqueue_export(params)
    enqueue(Export.create(params))
  end

  def create_and_enqueue_export!(params)
    enqueue(Export.create!(params))
  end

  def enqueue(export)
    export.transaction do
      export.save!
      case export.destination
      when :fax
        FaxApplicationJob.perform_later(export: export)
      when :email
        EmailApplicationJob.perform_later(export: export)
      when :sms
        ApplicationSubmittedSmsJob.perform_later(export: export)
      when :mi_bridges
        SubmitApplicationViaMiBridgesJob.perform_later(export: export)
      else
        raise UnknownExportTypeError, export.destination
      end
      export.transition_to(new_status: :queued)
    end
  end

  class UnknownExportTypeError < StandardError; end
end
