module Integrated
  class TransitionController < FormsController
    helper_method :step_count, :current_step

    def step_count
      return 6 if current_application.applying_for_both?
      current_application.applying_for_food_assistance? ? 5 : 4
    end

    def form_class
      NullStep
    end

    # override in subclasses
    def current_step; end
  end
end
