module Medicaid
  class TaxClaimedAsDependentController < MedicaidStepsController
    private

    def skip?
      current_application.filing_federal_taxes_next_year?
    end

    def update_application
      current_application.primary_member.update!(step_params)
    end
  end
end
