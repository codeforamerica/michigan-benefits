module Integrated
  class MobileHomeLotRentDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :mobile_home_lot_rent
    end
  end
end
