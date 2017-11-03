module Medicaid
  class IntroCaretakerMember < ManyMembersStep
    def valid?
      if members.select(&:caretaker_or_parent?).any?
        true
      else
        errors.add(
          :caretaker_or_parent,
          "Make sure you select at least one person",
        )
        false
      end
    end
  end
end
