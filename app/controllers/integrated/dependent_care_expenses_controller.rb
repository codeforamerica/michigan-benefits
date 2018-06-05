module Integrated
  class DependentCareExpensesController < FormsController
    include SingleExpense

    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
        SkipRules.multi_member_only(application),
      ]
    end

    def expense_type
      :disability_care
    end

    def expense_collection
      current_application.expenses.dependent_care
    end
  end
end
