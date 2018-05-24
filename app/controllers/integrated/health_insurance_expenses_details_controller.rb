module Integrated
  class HealthInsuranceExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :health_insurance
    end
  end
end
