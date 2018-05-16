class WhoIsMarriedForm < Form
  set_attributes_for :member, :married
  set_attributes_for :application, :members

  validate :at_least_one_person_married

  def at_least_one_person_married
    return true if members.any?(&:married_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
