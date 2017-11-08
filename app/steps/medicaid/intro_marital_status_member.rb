module Medicaid
  class IntroMaritalStatusMember < Step
    step_attributes(
      :members,
      :married,
    )

    def valid?
      if members.select(&:married?).any?
        true
      else
        errors.add(:married, "Make sure you select at least one person")
        false
      end
    end
  end
end
