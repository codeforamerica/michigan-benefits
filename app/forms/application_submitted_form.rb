class ApplicationSubmittedForm < Form
  set_attributes_for :application, :email

  validates_presence_of :email,
    message: "Make sure to enter an email address."
end
