class IntroduceYourself < Step
  self.title = "Introduction"
  self.headline = "We're here to help"
  self.subhead = "To start, please introduce yourself."

  def questions
    [
      FirstName,
      LastName,
      PhoneNumber,
      AcceptTextMessages,
    ].map { |q| q.new(@app) }
  end

  def next
    ChoosePrograms.new(@app)
  end
end
