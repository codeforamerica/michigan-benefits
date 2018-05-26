module Integrated
  class ExportFactory
    DELAY_THRESHOLD = 30

    def self.create(params)
      new.create(params)
    end

    def create(params)
      enqueue(Export.create(params))
    end

    def enqueue(export)
      export.transaction do
        export.save!
        case export.destination
        when :client_email
          Integrated::ClientEmailApplicationJob.perform_later(export: export)
        when :office_email
          Integrated::OfficeEmailApplicationJob.perform_later(export: export)
        else
          raise UnknownExportTypeError, export.destination
        end
        export.transition_to(new_status: :queued)
      end
    end

    class UnknownExportTypeError < StandardError; end
  end
end
