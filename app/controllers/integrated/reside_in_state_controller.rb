module Integrated
  class ResideInStateController < FormsController
    def update_models
      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
