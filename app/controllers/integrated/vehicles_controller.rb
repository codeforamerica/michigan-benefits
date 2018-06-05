module Integrated
  class VehiclesController < FormsController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def update_models
      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
