module Integrated
  class TransportationExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :transportation
    end
  end
end
