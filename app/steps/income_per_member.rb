class IncomePerMember < ManyMemberUpdateStep
  self.title = "Money & Income"
  self.subhead = "Tell us more about your household's employment"

  def pay_intervals
    ["Day", "Week", "2 Weeks", "Month"].map {|title| [title, title.parameterize]}
  end
end
