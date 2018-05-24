module Integrated
  class StudentLoanInterestDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :student_loan_interest
    end
  end
end
