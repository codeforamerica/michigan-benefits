# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { other_income: step_params[:anyone_other_income] }
    end
  end
end
