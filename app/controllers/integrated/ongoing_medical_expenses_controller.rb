module Integrated
  class OngoingMedicalExpensesController < FormsController
    include TypeCheckbox

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def checkbox_attribute
      :expense_type
    end

    def checkbox_options
      Expense::MEDICAL_EXPENSES.keys
    end

    def checkbox_collection
      current_application.expenses.medical
    end
  end
end
