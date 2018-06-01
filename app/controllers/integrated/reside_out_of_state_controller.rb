module Integrated
  class ResideOutOfStateController < FormsController
    def self.skip?(application)
      application.navigator.resides_in_state?
    end

    helper_method :program_descriptions

    def program_descriptions
      navigator = current_application.navigator
      [
        navigator.applying_for_healthcare ? "health coverage" : nil,
        navigator.applying_for_food ? "food assistance" : nil,
      ].compact.join(" and ")
    end

    def form_class
      NullStep
    end
  end
end
