class WhoIsVeteranForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :veteran

  validate :at_least_one_person_veteran

  def at_least_one_person_veteran
    return true if members.any?(&:veteran_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
