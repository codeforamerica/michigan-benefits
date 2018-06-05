module Integrated
  class FinishingUpController < TransitionController
    def current_step
      step_count + 1
    end
  end
end
