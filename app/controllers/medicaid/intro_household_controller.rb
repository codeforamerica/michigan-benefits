module Medicaid
  class IntroHouseholdController < MedicaidStepsController
    def edit
      @step = step_class.new(
        non_applicant_members: current_application.non_applicant_members,
        primary_member: current_application.primary_member,
      )
    end
  end
end
