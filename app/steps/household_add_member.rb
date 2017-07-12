# frozen_string_literal: true

class HouseholdAddMember < SimpleStep
  step_attributes \
    :first_name,
    :last_name,
    :sex,
    :relationship,
    :ssn,
    :in_home,
    :buy_food_with
end
