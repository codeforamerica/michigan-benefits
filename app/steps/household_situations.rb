class HouseholdSituations < ManyMemberUpdateStep
  self.title = "Your Household"
  self.subhead = "Ok, let us know which people these situations apply to."

  self.household_questions = {
    in_college: "Who is enrolled in college?",
    is_disabled: "Who has a disability?"
  }

  self.types = {
    in_college: :checkbox,
    is_disabled: :checkbox
  }

  def previous
    HouseholdMoreInfo.new(@app)
  end

  def next
    HouseholdHealth.new(@app)
  end
end
