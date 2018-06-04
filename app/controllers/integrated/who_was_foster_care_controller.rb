module Integrated
  class WhoWasFosterCareController < MultipleMembersPerPageController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      !application.navigator.anyone_foster_care_at_18?
    end

    def members_to_update
      current_application.members.select do |member|
        member.birthday.nil? || (member.age >= 18 && member.age <= 26)
      end
    end
  end
end
