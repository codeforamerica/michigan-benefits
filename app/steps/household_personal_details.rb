# frozen_string_literal: true

class HouseholdPersonalDetails < Step
  step_attributes \
    :sex,
    :marital_status,
    :ssn

  validates :sex,
    :marital_status,
    presence: { message: 'Make sure to answer this question.' }
end
