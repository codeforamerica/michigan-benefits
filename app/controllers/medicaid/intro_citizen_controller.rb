# frozen_string_literal: true

module Medicaid
  class IntroCitizenController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { citizen: step_params[:everyone_a_citizen] }
    end
  end
end
