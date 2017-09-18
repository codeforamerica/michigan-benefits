class ExportFactory
  DELAY_THRESHOLD = 30

  def self.create(params)
    new.create(params)
  end

  def self.create!(params)
    new.create!(params)
  end

  def self.export_unfaxed_snap_applications
    SnapApplication.
      faxable.
      untouched_since(DELAY_THRESHOLD.minutes.ago).
      find_each do |snap_application|
        create(
          destination: :fax,
          snap_application: snap_application,
        )
      end
  end

  def create(params)
    enqueue(Export.create(params))
  end

  def create!(params)
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
