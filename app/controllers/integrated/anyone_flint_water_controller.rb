module Integrated
  class AnyoneFlintWaterController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      members = application.members
      return false if members.any?(&:pregnant_yes?)
      return false if members.any?(&:pregnancy_expenses_yes?)
      return false if members.any? { |m| m.age.nil? }
      return false if members.any? { |m| m.age.present? && m.age < 21 }
      true
    end

    def update_models
      if params_for(:navigator)[:anyone_flint_water] == "false"
        current_application.members.update_all(flint_water: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
