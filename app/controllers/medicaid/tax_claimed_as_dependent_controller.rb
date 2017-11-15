module Medicaid
  class TaxClaimedAsDependentController < MedicaidStepsController
    private

    def skip?
      current_application.filing_federal_taxes_next_year?
    end

    def update_application
      current_application.primary_member.update!(member_attrs)
    end

    def member_attrs
      { claimed_as_dependent: step_params[:claimed_as_dependent] }
    end
  end
end
