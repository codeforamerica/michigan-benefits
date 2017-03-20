class AcceptTextMessages < Question
  self.title = "May we send text messages to that phone number help you through the enrollment process?"
  self.type = :yes_no
  self.model_attribute = :accepts_text_messages
end
