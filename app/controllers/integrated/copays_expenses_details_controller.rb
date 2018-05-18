module Integrated
  class CopaysExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :copays
    end
  end
end
