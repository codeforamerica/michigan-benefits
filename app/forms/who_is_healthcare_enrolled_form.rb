class WhoIsHealthcareEnrolledForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :healthcare_enrolled

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:healthcare_enrolled_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
