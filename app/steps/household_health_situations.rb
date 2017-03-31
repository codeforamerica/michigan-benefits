class HouseholdHealthSituations < ManyMemberUpdateStep
  self.title = "Your Household"
  self.subhead = "Ok, let us know which people these situations apply to."

  self.household_questions = {
    medical_help: "Who needs help paying for medical bills?",
    insurance_lost_last_3_months: "Who had insurance through a job and lost it in the last 3 months?"
  }

  self.types = {
    medical_help: :checkbox,
    insurance_lost_last_3_months: :checkbox
  }

  self.field_options = {
    medical_help: FieldOption.form_group_no_bottom_space,
    insurance_lost_last_3_months: FieldOption.form_group_no_bottom_space
  }

  def previous
    HouseholdHealth.new(@app)
  end

  def next
    HouseholdTax.new(@app)
  end
end
