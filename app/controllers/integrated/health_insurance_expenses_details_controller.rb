module Integrated
  class HealthInsuranceExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :health_insurance
    end
  end
end
