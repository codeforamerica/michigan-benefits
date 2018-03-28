class WhoIsCaretakerForm < Form
  set_application_attributes(:members)
  set_member_attributes(:caretaker)

  validate :at_least_one_person_caretaker

  def at_least_one_person_caretaker
    return true if members.any?(&:caretaker_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
