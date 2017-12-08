module Medicaid
  class InsuranceCurrentMember < Step
    step_attributes(:members)

    validate :members_needing_insurance_selected

    def members_needing_insurance_selected
      return true if members.select(&:insured).any?
      errors.add(
        :insured,
        "Make sure you select a person",
      )
    end
  end
end
