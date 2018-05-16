class WhoIsStudentForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :student

  validate :at_least_one_person_student

  def at_least_one_person_student
    return true if members.any?(&:student_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
