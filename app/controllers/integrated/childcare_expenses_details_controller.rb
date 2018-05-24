module Integrated
  class ChildcareExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :childcare
    end
  end
end
