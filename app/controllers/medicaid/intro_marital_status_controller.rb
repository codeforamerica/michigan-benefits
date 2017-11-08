module Medicaid
  class IntroMaritalStatusController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { married: step_params[:anyone_married] }
    end
  end
end
