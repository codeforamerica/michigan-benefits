class WhoIsStudentForm < Form
  set_application_attributes(:members)
  set_member_attributes(:student)

  validate :at_least_one_person_student

  def at_least_one_person_student
    return true if members.any?(&:student_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
