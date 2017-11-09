module Medicaid
  class ContactEmail < Step
    step_attributes(:email)

    validates :email,
      allow_blank: true,
      format: {
        with: /\A\S+@\S+\.\S+\z/,
        message: "Make sure you enter a valid email address",
      }
  end
end
