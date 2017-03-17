class LastName < Question
  self.title = "What is your last name?"
  self.placeholder = "(Last name)"

  def update(value)
    @app.last_name = value
  end
end
