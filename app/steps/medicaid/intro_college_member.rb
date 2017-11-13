module Medicaid
  class IntroCollegeMember < Step
    step_attributes(
      :in_college,
      :members,
    )

    validate :in_college_selected

    def in_college_selected
      return true if members.select(&:in_college?).any?
      errors.add(:in_college, "Make sure you select at least one person")
    end
  end
end
