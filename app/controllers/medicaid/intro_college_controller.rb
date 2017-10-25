# frozen_string_literal: true

module Medicaid
  class IntroCollegeController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { in_college: step_params[:anyone_in_college] }
    end
  end
end
