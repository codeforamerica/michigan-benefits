module Medicaid
  class IntroHouseholdMember < Step
    step_attributes(
      :first_name,
      :last_name,
      :sex,
    )
  end
end
