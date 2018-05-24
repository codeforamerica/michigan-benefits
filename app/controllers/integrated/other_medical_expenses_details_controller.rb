module Integrated
  class OtherMedicalExpensesDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :other_medical
    end
  end
end
