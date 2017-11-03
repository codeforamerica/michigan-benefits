# frozen_string_literal: true

module Medicaid
  class PaperworkController < MedicaidStepsController
    private

    def skip?
      not_uploading_paperwork?
    end

    def not_uploading_paperwork?
      !current_application&.upload_paperwork?
    end
  end
end
