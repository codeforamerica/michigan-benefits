module Integrated
  class YourHousingExpensesDetailsController < FormsController
    include ManyExpensesDetails
    extend ManyExpensesDetails::ClassMethods

    def self.expenses_scope
      :housing
    end
  end
end
