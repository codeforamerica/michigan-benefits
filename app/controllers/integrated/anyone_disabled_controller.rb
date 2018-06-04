module Integrated
  class AnyoneDisabledController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def update_models
      if params_for(:navigator)[:anyone_disabled] == "false"
        current_application.members.update_all(disabled: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
