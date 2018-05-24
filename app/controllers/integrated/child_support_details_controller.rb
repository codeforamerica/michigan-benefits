module Integrated
  class ChildSupportDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :child_support
    end
  end
end
