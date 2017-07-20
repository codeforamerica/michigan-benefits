# frozen_string_literal: true

class HouseholdSituations < Step
  step_attributes \
    :household_members,
    :everyone_a_citizen,
    :anyone_disabled,
    :any_new_moms,
    :anyone_in_college,
    :anyone_living_elsewhere
end
