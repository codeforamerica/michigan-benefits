class IntroduceYourself < Step
  self.title = "Introduction"
  self.headline = "We're here to help"
  self.subhead = "To start, please introduce yourself."
  self.questions = [
    FirstName,
    LastName,
    PhoneNumber,
    AcceptTextMessages,
  ]

  def next
    ChoosePrograms.new(@app)
  end
end
