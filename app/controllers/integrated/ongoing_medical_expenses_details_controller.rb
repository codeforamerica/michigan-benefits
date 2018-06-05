module Integrated
  class OngoingMedicalExpensesDetailsController < FormsController
    include ManyExpensesDetails
    extend ManyExpensesDetails::ClassMethods

    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def self.expenses_scope
      :medical
    end
  end
end
