module Integrated
  class StudentLoanInterestController < FormsController
    include SingleExpense

    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def expense_type
      :student_loan_interest
    end

    def expense_collection
      current_application.expenses.student_loan_interest
    end
  end
end
