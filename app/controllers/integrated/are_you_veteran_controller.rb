module Integrated
  class AreYouVeteranController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.single_member_only(application)]
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
