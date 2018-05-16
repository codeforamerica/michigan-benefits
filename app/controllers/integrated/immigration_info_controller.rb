module Integrated
  class ImmigrationInfoController < FormsController
    def self.skip?(application)
      application.navigator.everyone_citizen?
    end

    def update_models
      current_application.navigator.update(params_for(:navigator))
    end
  end
end
