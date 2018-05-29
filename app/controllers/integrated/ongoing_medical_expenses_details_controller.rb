module Integrated
  class OngoingMedicalExpensesDetailsController < FormsController
    include ManyExpensesDetails
    extend ManyExpensesDetails::ClassMethods

    def self.expenses_scope
      :medical
    end
  end
end
