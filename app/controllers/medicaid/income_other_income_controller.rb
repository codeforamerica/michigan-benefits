module Medicaid
  class IncomeOtherIncomeController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      { other_income: step_params[:anyone_other_income] }
    end
  end
end
