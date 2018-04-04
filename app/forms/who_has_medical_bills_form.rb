class WhoHasMedicalBillsForm < Form
  set_application_attributes(:members)
  set_member_attributes(:medical_bills)

  validate :at_least_one_person

  def at_least_one_person
    return true if members.any?(&:medical_bills_yes?)
    errors.add(:members, "Make sure you select at least one person")
  end
end
