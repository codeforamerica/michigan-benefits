# frozen_string_literal: true

class PersonalDetail < Step
  step_attributes(
    :sex,
    :marital_status,
    :social_security_number,
  )

  validates :sex, inclusion: {
    in: %w(male female),
    message: "Make sure to answer this question",
  }

  validates :marital_status, inclusion: {
    in: ["Married", "Never married", "Divorced", "Widowed", "Separated"],
    message: "Make sure to answer this question",
  }
end
