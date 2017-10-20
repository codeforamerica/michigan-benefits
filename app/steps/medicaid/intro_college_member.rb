# frozen_string_literal: true

module Medicaid
  class IntroCollegeMember < Step
    step_attributes(
      :in_college,
      :members,
    )

    def valid?
      if members.select(&:in_college?).any?
        true
      else
        errors.add(
          :in_college,
            "Make sure you select at least one person",
        )
        false
      end
    end
  end
end
