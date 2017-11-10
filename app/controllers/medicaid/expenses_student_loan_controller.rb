module Medicaid
  class ExpensesStudentLoanController < MedicaidStepsController
    private

    def update_application
      super

      if single_member_household?
        current_application.primary_member.update!(member_attrs)
      end
    end

    def member_attrs
      {
        pay_student_loan_interest:
          step_params[:anyone_pay_student_loan_interest],
      }
    end
  end
end
