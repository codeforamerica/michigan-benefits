class LastName < Question
  self.title = "What is your last name?"
  self.placeholder = "(Last name)"
  self.model_attribute = :last_name

  validates :value, presence: { message: "Make sure to provide a last name" }
end
