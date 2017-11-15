module Medicaid
  class TaxFilingWithHouseholdMembersMemberController <
    Medicaid::ManyMemberStepsController

    private

    def member_attrs
      %i[filing_taxes_with_primary_member]
    end

    def skip?
      single_member_household? ||
        !current_application.filing_federal_taxes_next_year? ||
        !current_application.filing_taxes_with_household_members?
    end
  end
end
