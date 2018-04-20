module Integrated
  class AlimonyController < FormsController
    include SingleExpense

    def expense_type
      :alimony
    end

    def expense_collection
      current_application.expenses.court_ordered
    end
  end
end
