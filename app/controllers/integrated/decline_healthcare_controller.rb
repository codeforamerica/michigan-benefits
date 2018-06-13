module Integrated
  class DeclineHealthcareController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.must_not_be_applying_for_healthcare(application)]
    end

    def self.custom_skip_rule_set(application)
      !application.navigator.applying_for_healthcare?
    end

    def form_class
      NullStep
    end
  end
end
