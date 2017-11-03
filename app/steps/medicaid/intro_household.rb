module Medicaid
  class IntroHousehold < Step
    step_attributes(
      :primary_member,
      :non_applicant_members,
    )
  end
end
