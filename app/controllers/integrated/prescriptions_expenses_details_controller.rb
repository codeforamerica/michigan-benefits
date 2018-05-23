module Integrated
  class PrescriptionsExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :prescriptions
    end
  end
end
