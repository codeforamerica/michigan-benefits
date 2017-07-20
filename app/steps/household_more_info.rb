# frozen_string_literal: true

class HouseholdMoreInfo < Step
  step_attributes \
    :everyone_a_citizen,
    :anyone_disabled,
    :any_new_moms,
    :anyone_in_college,
    :anyone_living_elsewhere

  validates \
    *attribute_names,
    presence: { message: 'Make sure to answer this question' }
end
