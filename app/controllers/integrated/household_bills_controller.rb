module Integrated
  class HouseholdBillsController < TransitionController
    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
      ]
    end

    def current_step
      3 if current_application.applying_for_food_assistance?
    end
  end
end
