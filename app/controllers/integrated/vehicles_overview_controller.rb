module Integrated
  class VehiclesOverviewController < FormsController
    def self.skip_rule_sets(application)
      super << SkipRules.must_be_applying_for_food_assistance(application)
    end

    def self.custom_skip_rule_set(application)
      !application.navigator.own_vehicles
    end

    def form_class
      NullStep
    end
  end
end
