module Integrated
  class ChildSupportController < FormsController
    include SingleExpense

    def expense_type
      :child_support
    end

    def expense_collection
      current_application.expenses.court_ordered
    end
  end
end
