module Integrated
  class StudentLoanInterestDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :student_loan_interest
    end
  end
end
