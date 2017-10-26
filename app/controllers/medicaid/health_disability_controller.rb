# frozen_string_literal: true

module Medicaid
  class HealthDisabilityController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { disabled: step_params[:anyone_disabled] }
    end
  end
end
