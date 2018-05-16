class WhoIsSelfEmployedForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :self_employed

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:self_employed_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
