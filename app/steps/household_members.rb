class HouseholdMembers < Step
  self.title = "Your Household"
  self.subhead = "Members of your household"

  def static_template
    "steps/household_members"
  end

  def previous
    YourHousehold.new(@app)
  end

  def next
    HouseholdMeta.new(@app)
  end

  def assign_from_app
  end

  def update_app!
  end
end
