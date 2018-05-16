class SignSubmitForm < Form
  set_attributes_for :application, :signature

  validates :signature,
    presence: { message: "Make sure you enter your full legal name" }
end
