module Integrated
  class UtilityExpensesController < FormsController
    include TypeCheckbox

    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
      ]
    end

    def checkbox_attribute
      :expense_type
    end

    def checkbox_options
      Expense::UTILITY_EXPENSES.keys
    end

    def checkbox_collection
      current_application.expenses.utilities
    end
  end
end
