module Integrated
  class VehiclesOverviewController < FormsController
    def self.skip?(application)
      !application.navigator.own_vehicles
    end

    def form_class
      NullStep
    end
  end
end
