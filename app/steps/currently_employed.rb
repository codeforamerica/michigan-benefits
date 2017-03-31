class CurrentlyEmployed < ManyMemberUpdateStep
  self.title = "Money & Income"
  self.subhead = "Who in your household is currently employed, or has been in the past 30 days?"
  self.subhead_help = "Employment includes temporary or contract jobs. Self employment includes odd jobs, home businesses, online businesses, etc."

  self.member_questions = [:employment_status]

  self.field_options = {
    employment_status: HouseholdMember::EMPLOYMENT_STATUSES
  }

  def previous
    if @app.income_change?
      IncomeChangeExplanation.new(@app)
    else
      IncomeChange.new(@app)
    end
  end

  def next
    AdditionalIncome.new(@app)
  end
end
