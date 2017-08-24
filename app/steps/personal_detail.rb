# frozen_string_literal: true

require_relative "./concerns/social_security_number.rb"

class PersonalDetail < Step
  extend AutoStripAttributes
  include SocialSecurityNumber

  step_attributes(
    :sex,
    :marital_status,
    :ssn,
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
