# frozen_string_literal: true

class SignAndSubmit < Step
  step_attributes :signature

  validates :signature,
    presence: { message: "Make sure you enter your signature" }
end
