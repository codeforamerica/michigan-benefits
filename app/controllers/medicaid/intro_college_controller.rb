module Medicaid
  class IntroCollegeController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { in_college: step_params[:anyone_in_college] }
    end
  end
end
