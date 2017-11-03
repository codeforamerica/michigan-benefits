module Medicaid
  class SignAndSubmit < Step
    step_attributes(
      :signature,
      :signed_at,
    )

    validates :signature,
      presence: { message: "Make sure you enter your signature" }
  end
end
