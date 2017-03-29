class HouseholdIntroduction < Step
  self.title = "Introduction"
  self.subhead = "There are 4 sections you need to complete to submit a full application."

  def previous
    IntroductionComplete.new(@app)
  end

  def next
    YourHousehold.new(@app)
  end

  def assign_from_app
  end

  def update_app!
  end
end
