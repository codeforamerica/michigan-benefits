module Integrated
  class PropertyTaxDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.expense_type
      :property_tax
    end
  end
end
