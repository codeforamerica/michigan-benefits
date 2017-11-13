module Medicaid
  class ExpensesStudentLoanMember < Step
    step_attributes(
      :members,
      :pay_student_loan_interest,
    )

    validate :pay_student_loan_interest_selected

    def pay_student_loan_interest_selected
      return true if members.select(&:pay_student_loan_interest).any?
      errors.add(
        :student_loan_interest,
        "Make sure you select at least one person",
      )
    end
  end
end
