module Integrated
  class VehiclesController < FormsController
    def update_models
      current_application.navigator.update!(navigator_params)
    end
  end
end
