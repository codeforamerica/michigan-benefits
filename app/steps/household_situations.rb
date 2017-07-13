# frozen_string_literal: true

class HouseholdSituations < SimpleStep
  step_attributes \
    :household_members,
    :everyone_a_citizen,
    :anyone_disabled,
    :any_new_moms,
    :anyone_in_college,
    :anyone_living_elsewhere
end
