class FirstName < Question
  self.title = "What is your first name?"
  self.placeholder = "(First name)"

  def update(value)
    @app.first_name = value
  end
end
