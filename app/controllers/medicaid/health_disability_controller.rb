module Medicaid
  class HealthDisabilityController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { disabled: step_params[:anyone_disabled] }
    end
  end
end
