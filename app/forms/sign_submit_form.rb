class SignSubmitForm < Form
  set_application_attributes(:signature)

  validates :signature,
    presence: { message: "Make sure you enter your full legal name" }
end
