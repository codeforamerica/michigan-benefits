module Integrated
  class OngoingMedicalExpensesController < FormsController
    include TypeCheckbox

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
