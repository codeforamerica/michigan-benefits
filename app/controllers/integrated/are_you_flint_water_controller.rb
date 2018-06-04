module Integrated
  class AreYouFlintWaterController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.single_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      member = application.primary_member
      return false if member.pregnant_yes?
      return false if member.pregnancy_expenses_yes?
      return false if member.age.nil?
      return false if member.age.present? && member.age < 21
      true
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
