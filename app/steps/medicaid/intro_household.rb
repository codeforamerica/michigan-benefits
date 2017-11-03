module Medicaid
  class IntroHousehold < Step
    step_attributes(
      :first_name,
      :last_name,
      :non_applicant_members,
    )
  end
end
