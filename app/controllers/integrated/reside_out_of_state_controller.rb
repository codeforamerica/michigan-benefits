module Integrated
  class ResideOutOfStateController < FormsController
    def self.skip?(application)
      application.navigator.resides_in_state?
    end

    def form_class
      NullStep
    end
  end
end
