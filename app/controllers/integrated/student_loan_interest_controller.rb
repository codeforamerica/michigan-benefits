module Integrated
  class StudentLoanInterestController < FormsController
    include SingleExpense

    def expense_type
      :student_loan_interest
    end

    def expense_collection
      current_application.expenses.student_loan_interest
    end
  end
end
