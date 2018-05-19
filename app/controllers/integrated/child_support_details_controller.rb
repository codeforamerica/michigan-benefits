module Integrated
  class ChildSupportDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :child_support
    end
  end
end
