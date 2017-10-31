# frozen_string_literal: true

module Medicaid
  class ExpensesStudentLoanMember < ManyMembersStep
    step_attributes(
      :members,
      :pay_student_loan_interest,
    )

    def valid?
      if members.select(&:pay_student_loan_interest).any?
        true
      else
        errors.add(
          :student_loan_interest,
          "Make sure you select at least one person",
        )
        false
      end
    end
  end
end
