class HouseholdIntroduction < Step
  self.title = "Introduction"
  self.subhead = "There are 4 sections you need to complete to submit a full application."
  self.icon = "section-1"

  def previous
    IntroductionComplete.new(@app)
  end

  def next
    HouseholdPersonalDetails.new(@app)
  end

  def assign_from_app
  end

  def update_app!
  end
end
