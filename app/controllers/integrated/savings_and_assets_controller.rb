module Integrated
  class SavingsAndAssetsController < TransitionController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def current_step
      return 6 if current_application.applying_for_both?
      5 if current_application.applying_for_food_assistance?
    end
  end
end
