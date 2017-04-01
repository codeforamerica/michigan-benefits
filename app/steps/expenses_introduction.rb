class ExpensesIntroduction < Step
  self.title = "Expenses"
  self.headline = "You're halfway there!"
  self.subhead = "Next, describe your household expenses."
  self.icon = "section-3"

  def previous
    LegalAgreement.new(@app)
  end

  def next
    ExpensesHousing.new(@app)
  end

  def assign_from_app
  end

  def update_app!
  end
end
