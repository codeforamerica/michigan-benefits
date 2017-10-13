# frozen_string_literal: true

module Medicaid
  class IntroName < Step
    step_attributes(
      :first_name,
      :last_name,
      :gender,
    )

    validates :first_name,
      presence: { message: "Make sure to provide a first name" }

    validates :last_name,
      presence: { message: "Make sure to provide a last name" }

    validates :gender, inclusion: {
      in: %w(male female),
      message: "Make sure to answer this question",
    }
  end
end
