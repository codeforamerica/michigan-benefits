# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentMember < Step
    step_attributes(
      :is_insured,
      :members,
    )

    def valid?
      if members.select(&:is_insured).any?
        true
      else
        errors.add(
          :is_insured,
          "Please select a member",
        )
        false
      end
    end
  end
end
