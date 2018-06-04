module Integrated
  class AnyoneMarriedController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def self.custom_skip_rule_set(application)
      application.navigator.anyone_married?
    end

    def update_models
      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
