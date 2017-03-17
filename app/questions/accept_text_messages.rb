class AcceptTextMessages < Question
  self.title = "May we send text messages to that phone number help you through the enrollment process?"
  self.type = :yes_no

  def update(value)
    @app.accepts_text_messages = (value.downcase.in? %w[yes true 1])
  end
end
