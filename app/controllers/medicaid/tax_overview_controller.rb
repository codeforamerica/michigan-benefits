module Medicaid
  class TaxOverviewController < MedicaidStepsController
    delegate(
      :members,
      :filing_federal_taxes_next_year?,
      :filing_taxes_with_household_members?,
      to: :current_application,
    )

    helper_method :members

    def step_class
      NullStep
    end

    def skip?
      return false if members.any?(&:claimed_as_dependent?)

      single_member_household? ||
        !filing_federal_taxes_next_year? ||
        !filing_taxes_with_household_members?
    end
  end
end
