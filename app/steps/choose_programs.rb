class ChoosePrograms < Step
  self.title = "Introduction"
  self.headline = "Welcome"
  self.subhead = "Choose the programs you want to apply for today."

  def questions
    [
    ].map(&:new)
  end

  def next
    nil
  end
end
