module Integrated
  class UtilityExpensesController < FormsController
    include TypeCheckbox

    def checkbox_attribute
      :expense_type
    end

    def checkbox_options
      Expense::UTILITY_EXPENSES.keys
    end

    def checkbox_collection
      current_application.expenses
    end
  end
end
