module Integrated
  class InHomeCareExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :in_home_care
    end
  end
end
