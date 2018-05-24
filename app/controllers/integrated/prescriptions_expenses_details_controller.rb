module Integrated
  class PrescriptionsExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :prescriptions
    end
  end
end
