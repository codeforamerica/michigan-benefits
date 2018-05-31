module Integrated
  class VehiclesOverviewController < FormsController
    def self.custom_skip_rule_set(application)
      !application.navigator.own_vehicles
    end

    def form_class
      NullStep
    end
  end
end
