module Integrated
  class HousingExpensesController < FormsController
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
      Expense::HOUSING_EXPENSES.keys
    end

    def checkbox_collection
      current_application.expenses.housing
    end
  end
end
