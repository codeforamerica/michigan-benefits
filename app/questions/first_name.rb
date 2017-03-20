class FirstName < Question
  self.title = "What is your first name?"
  self.placeholder = "(First name)"
  self.model_attribute = :first_name

  validates :value, presence: { message: "Make sure to provide a first name" }
end
