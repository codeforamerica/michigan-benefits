class WhoIsNotCitizenForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :citizen

  validate :at_least_one_person_not_citizen

  def at_least_one_person_not_citizen
    return true if members.any?(&:citizen_no?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
