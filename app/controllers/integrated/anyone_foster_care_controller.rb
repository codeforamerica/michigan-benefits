module Integrated
  class AnyoneFosterCareController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      application.members.all? do |member|
        member.age.present? && (member.age < 18 || member.age > 26)
      end
    end

    def update_models
      if params_for(:navigator)[:anyone_foster_care_at_18] == "false"
        current_application.members.update_all(foster_care_at_18: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
