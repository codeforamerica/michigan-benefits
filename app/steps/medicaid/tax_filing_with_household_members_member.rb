module Medicaid
  class TaxFilingWithHouseholdMembersMember < Step
    step_attributes :members

    validate :filing_taxes_with_primary_member_selected

    def filing_taxes_with_primary_member_selected
      return true if members.select(
        &:filing_taxes_with_primary_member?
      ).any?
      errors.add(
        :filing_taxes_with_primary_member,
        "Make sure you select at least one person",
      )
    end
  end
end
