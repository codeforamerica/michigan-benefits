module Integrated
  class OtherMedicalExpensesDetailsController < FormsController
    include ExpensesDetails
    extend ExpensesDetails::ClassMethods

    def self.expense_type
      :other_medical
    end
  end
end
