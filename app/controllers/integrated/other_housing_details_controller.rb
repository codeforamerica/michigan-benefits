module Integrated
  class OtherHousingDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :other_housing
    end
  end
end
