# frozen_string_literal: true

module Medicaid
  class IncomeJobController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { employment_status: employed_params }
    end

    def employed_params
      if step_params[:anyone_employed] == "true"
        "employed"
      end
    end
  end
end
