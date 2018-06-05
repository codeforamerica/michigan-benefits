module Integrated
  class HealthAndInsuranceController < TransitionController
    def self.skip_rule_sets(application)
      [SkipRules.must_be_applying_for_healthcare(application)]
    end

    def current_step
      return 4 if current_application.applying_for_both?
      3 if current_application.applying_for_healthcare?
    end
  end
end
