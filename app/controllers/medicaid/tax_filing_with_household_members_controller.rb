module Medicaid
  class TaxFilingWithHouseholdMembersController < MedicaidStepsController
    private

    def step_class
      Medicaid::TaxFilingWithHouseholdMembers
    end

    def skip?
      single_member_household? ||
        !current_application.filing_federal_taxes_next_year?
    end
  end
end
