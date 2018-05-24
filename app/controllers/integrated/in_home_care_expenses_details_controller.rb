module Integrated
  class InHomeCareExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :in_home_care
    end
  end
end
