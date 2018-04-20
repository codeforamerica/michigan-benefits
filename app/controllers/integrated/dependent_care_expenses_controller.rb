module Integrated
  class DependentCareExpensesController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    include SingleExpense

    def expense_type
      :disability_care
    end

    def expense_collection
      current_application.expenses.dependent_care
    end
  end
end
