# frozen_string_literal: true

class HouseholdTax < Step
  step_attributes :household_tax

  validates \
    :household_tax,
    presence: { message: "Make sure to answer this question" }
end
