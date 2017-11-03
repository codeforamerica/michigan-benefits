module Medicaid
  class IntroHouseholdController < MedicaidStepsController
    def edit
      @step = step_class.new(
        first_name: current_application.primary_member.first_name,
        last_name: current_application.primary_member.last_name,
        non_applicant_members: current_application.non_applicant_members,
      )
    end
  end
end
