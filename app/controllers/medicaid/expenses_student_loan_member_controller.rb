# frozen_string_literal: true

module Medicaid
  class ExpensesStudentLoanMemberController <
    Medicaid::ManyMemberStepsController

    private

    def skip?
      nobody_pays_student_loan_interest? || single_member_household?
    end

    def member_attrs
      %i[pay_student_loan_interest]
    end

    def nobody_pays_student_loan_interest?
      !current_application.anyone_pay_student_loan_interest?
    end
  end
end
