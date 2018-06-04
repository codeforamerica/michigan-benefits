module Integrated
  class WhoIsFlintWaterController < MultipleMembersPerPageController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      !application.navigator.anyone_flint_water?
    end
  end
end
