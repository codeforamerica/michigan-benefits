module Integrated
  class SavingsAndAssetsController < FormsController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def form_class
      NullStep
    end
  end
end
