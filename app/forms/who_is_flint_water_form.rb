class WhoIsFlintWaterForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :flint_water

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:flint_water_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
