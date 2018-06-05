module Integrated
  class OtherHousingDetailsController < FormsController
    include SingleExpenseDetails
    extend SingleExpenseDetails::ClassMethods

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def self.expense_type
      :other_housing
    end
  end
end
