module Integrated
  class DentalExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :dental
    end
  end
end
