module Medicaid
  class OfficeLocationController < MedicaidStepsController
    private

    def skip?
      current_application.office_page.present?
    end
  end
end
