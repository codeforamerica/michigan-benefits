# frozen_string_literal: true

class HouseholdPersonalDetails < SimpleStep
  step_attributes \
    :sex,
    :marital_status,
    :ssn

  validates :sex,
    :marital_status,
    presence: { message: 'Make sure to answer this question.' }
end
