module Medicaid
  class ExpensesStudentLoanMember < ManyMembersStep
    step_attributes(
      :members,
      :pay_student_loan_interest,
    )

    def members_valid
      return true if members.select(&:pay_student_loan_interest).any?
      errors.add(
        :student_loan_interest,
        "Make sure you select at least one person",
      )
    end
  end
end
