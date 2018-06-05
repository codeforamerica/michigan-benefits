module Integrated
  class AlimonyController < FormsController
    include SingleExpense

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def expense_type
      :alimony
    end

    def expense_collection
      current_application.expenses.court_ordered
    end
  end
end
