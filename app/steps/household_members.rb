class HouseholdMembers < Step
  self.title = "Your Household"
  self.subhead = "Members of your household"

  def skip?
    @app.household_size.to_i == 1
  end

  def assign_from_app
  end

  def update_app!
  end
end
