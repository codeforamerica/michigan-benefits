module Integrated
  class AlimonyDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :alimony
    end
  end
end
