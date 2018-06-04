module Integrated
  class StudentLoanInterestDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_healthcare(application)
    end

    def self.expense_type
      :student_loan_interest
    end
  end
end
