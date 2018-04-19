module Integrated
  class HousingExpensesController < FormsController
    include TypeCheckbox

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
