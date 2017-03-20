class PhoneNumber < Question
  self.title = "What is the best phone number to reach you?"
  self.placeholder = "(555-555-5555)"
  self.model_attribute = :phone_number

  validates :value, presence: { message: "Make sure your phone number is 10 digits long" }
end
