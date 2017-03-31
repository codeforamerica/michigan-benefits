class HouseholdTaxHow < Step
  self.title = "Your Household"
  self.subhead = "Describe how your household files taxes."
  self.subhead_help = "If you aren't sure how your household files taxes right now, it is okay to skip these questions. We'll help you answer later."

  self.member_questions = [:filing_status]

  self.field_options = {
    filing_status: HouseholdMember::FILING_STATUSES
  }

  def previous
    HouseholdTax.new(@app)
  end

  def next
    IncomeIntroduction.new(@app)
  end

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
