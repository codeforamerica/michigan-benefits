module Medicaid
  class IntroCaretakerMember < Step
    step_attributes :members

    validate :caretaker_or_parent_selected

    def caretaker_or_parent_selected
      return true if members.select(&:caretaker_or_parent?).any?
      errors.add(
        :caretaker_or_parent,
        "Make sure you select at least one person",
      )
    end
  end
end
