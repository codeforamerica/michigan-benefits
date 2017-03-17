class PhoneNumber < Question
  self.title = "What is the best phone number to reach you?"
  self.placeholder = "(555-555-5555)"

  def update(value)
    @app.phone_number = value
  end
end
