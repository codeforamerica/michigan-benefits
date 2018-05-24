module Integrated
  class CopaysExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :copays
    end
  end
end
