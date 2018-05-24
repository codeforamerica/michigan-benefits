module Integrated
  class HomeownersInsuranceDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :homeowners_insurance
    end
  end
end
