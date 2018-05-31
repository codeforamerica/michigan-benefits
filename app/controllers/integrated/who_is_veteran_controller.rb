module Integrated
  class WhoIsVeteranController < MultipleMembersPerPageController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def self.custom_skip_rule_set(application)
      !application.navigator.anyone_veteran?
    end
  end
end
