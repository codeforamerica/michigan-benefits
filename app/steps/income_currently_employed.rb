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

  def validate_household_member(member)
    unless member.employment_status.present?
      member.errors.add(:employment_status, "Make sure you answer this question")
    end
  end
end
