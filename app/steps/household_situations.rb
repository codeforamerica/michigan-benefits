class HouseholdSituations < ManyMemberUpdateStep
  self.title = "Your Household"
  self.subhead = "Ok, let us know which people these situations apply to."

  def skip?
    @app.everyone_a_citizen &&
      ! @app.anyone_disabled &&
      ! @app.any_new_moms &&
      ! @app.anyone_in_college &&
      ! @app.anyone_living_elsewhere
  end
end
