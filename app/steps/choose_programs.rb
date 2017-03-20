class ChoosePrograms < Step
  self.title = "Introduction"
  self.headline = "Welcome"
  self.subhead = "Choose the programs you want to apply for today."
  self.questions = []

  def previous
    IntroduceYourself.new(@app)
  end

  def next
    nil
  end
end
