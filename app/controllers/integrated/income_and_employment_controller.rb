module Integrated
  class IncomeAndEmploymentController < TransitionController
    def current_step
      current_application.applying_for_both? ? 5 : 4
    end
  end
end
