module Integrated
  class WhoIsMarriedController < MultipleMembersPerPageController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def self.custom_skip_rule_set(application)
      true unless application.navigator.anyone_married?
    end
  end
end
