module Integrated
  class AlimonyDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :alimony
    end
  end
end
