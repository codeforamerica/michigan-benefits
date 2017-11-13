module Medicaid
  class IntroCaretakerMember < ManyMembersStep
    def members_valid
      return true if members.select(&:caretaker_or_parent?).any?
      errors.add(
        :caretaker_or_parent,
        "Make sure you select at least one person",
      )
    end
  end
end
