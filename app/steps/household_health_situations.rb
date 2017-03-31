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

  def previous
    HouseholdHealth.new(@app)
  end

  def next
    HouseholdTax.new(@app)
  end
end
