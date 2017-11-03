module Medicaid
  class IncomeJobController < MedicaidStepsController
    private

    def after_successful_update_hook
      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { employed: step_params[:anyone_employed] }
    end
  end
end
