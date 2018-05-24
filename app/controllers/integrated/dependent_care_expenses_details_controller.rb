module Integrated
  class DependentCareExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :disability_care
    end
  end
end
