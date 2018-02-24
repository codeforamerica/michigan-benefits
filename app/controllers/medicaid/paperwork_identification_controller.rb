module Medicaid
  class PaperworkIdentificationController < MedicaidStepsController
    private

    def skip?
      current_application.applied_before_yes?
    end
  end
end
