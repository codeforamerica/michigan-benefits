module Integrated
  class WereYouFosterCareController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.single_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      if age = application.primary_member.age
        true if age < 18 || age > 26
      end
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
