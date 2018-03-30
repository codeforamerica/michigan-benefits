class WhoIsNotCitizenForm < Form
  set_application_attributes(:members)
  set_member_attributes(:citizen)

  validate :at_least_one_person_not_citizen

  def at_least_one_person_not_citizen
    return true if members.any?(&:citizen_no?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
