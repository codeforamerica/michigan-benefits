# frozen_string_literal: true

module Medicaid
  class ContactEmail < Step
    step_attributes(:email)

    validates :email,
      allow_blank: true,
      format: {
        with: /\A\S+@\S+\.\S+\z/,
        message: "Please enter a valid email address",
      }
  end
end
