module Integrated
  class MortgageDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :mortgage
    end
  end
end
