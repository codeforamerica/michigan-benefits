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

  self.field_options = {
    in_college: FieldOption.form_group_no_bottom_space,
    is_disabled: FieldOption.form_group_no_bottom_space
  }
end
