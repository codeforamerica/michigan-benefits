module Integrated
  class EveryoneCitizenController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def update_models
      if params_for(:navigator)[:everyone_citizen] == "true"
        current_application.members.update_all(citizen: "yes")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
