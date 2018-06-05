module Integrated
  class HasYourIncomeChangedController < FormsController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
