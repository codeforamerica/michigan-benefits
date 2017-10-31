# frozen_string_literal: true

module Medicaid
  class ExpensesStudentLoan < Step
    step_attributes(
      :anyone_pay_student_loan_interest,
      :members,
    )
  end
end
