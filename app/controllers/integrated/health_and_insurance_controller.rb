module Integrated
  class HealthAndInsuranceController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.must_be_applying_for_healthcare(application)]
    end

    def form_class
      NullStep
    end
  end
end
