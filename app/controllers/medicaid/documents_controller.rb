# frozen_string_literal: true

module Medicaid
  class DocumentsController < MedicaidStepsController
    def next_path
      medicaid_root_path(anchor: "fold")
    end

    private

    def skip?
      not_uploading_documents?
    end

    def not_uploading_documents?
      !current_application&.upload_documents?
    end
  end
end
