class ManyMemberUpdateStep < Step
  def update(params)
    member_updates = params["household_members"]
    if member_updates&.keys && member_updates&.values
      HouseholdMember.update(
        member_updates.keys,
        member_updates.values
      )
    end
  end

  def assign_from_app; end
end
