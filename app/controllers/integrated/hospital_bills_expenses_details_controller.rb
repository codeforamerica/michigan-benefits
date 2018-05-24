module Integrated
  class HospitalBillsExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :hospital_bills
    end
  end
end
