module Integrated
  class HospitalBillsExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :hospital_bills
    end
  end
end
