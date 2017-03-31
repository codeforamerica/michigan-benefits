class ChoosePrograms < Step
  self.title = "Introduction"
  self.headline = "Welcome"
  self.subhead = "Choose the programs you want to apply for today."
  self.questions = []

  def previous
    IntroductionIntroduceYourself.new(@app)
  end

  def next
    nil
  end

  def assign_from_app
  end

  def update_app!
  end
end
