class WhoWasFosterCareForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :foster_care_at_18

  validate :at_least_one_person_foster_care_at_18

  def at_least_one_person_foster_care_at_18
    return true if members.any?(&:foster_care_at_18_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
