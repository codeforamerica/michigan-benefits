module Integrated
  class PrescriptionsExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def self.expense_type
      :prescriptions
    end
  end
end
