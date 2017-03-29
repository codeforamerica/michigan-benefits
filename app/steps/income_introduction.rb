class IncomeIntroduction < Step
  self.title = "Money & Income"
  self.subhead = "Next, describe your financial situation for us."
  self.icon = "section-2"
  self.headline = "You’re doing great!"

  def static_template
    "steps/income_introduction"
  end

  def previous
    HouseholdIntroduction.new(@app)
  end

  def next
    IncomeChange.new(@app)
  end

  def assign_from_app
  end

  def update_app!
  end
end
