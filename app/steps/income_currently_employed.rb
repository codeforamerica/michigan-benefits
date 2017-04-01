class IncomeCurrentlyEmployed < ManyMemberUpdateStep
  self.title = "Money & Income"
  self.subhead = "Who in your household is currently employed, or has been in the past 30 days?"
  self.subhead_help = "Employment includes temporary or contract jobs. Self employment includes odd jobs, home businesses, online businesses, etc."

  self.member_questions = {
    employment_status: ["Employment status", :hidden]
  }

  self.types = {
    employment_status: :radios
  }

  self.field_options = {
    employment_status: HouseholdMember::EMPLOYMENT_STATUSES.map(&:to_s)
  }

  def previous
    if @app.income_change?
      IncomeChangeExplanation.new(@app)
    else
      IncomeChange.new(@app)
    end
  end

  def next
    IncomePerMember.new(@app)
  end
end
