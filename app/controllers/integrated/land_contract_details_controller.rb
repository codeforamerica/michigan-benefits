module Integrated
  class LandContractDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :land_contract
    end
  end
end
