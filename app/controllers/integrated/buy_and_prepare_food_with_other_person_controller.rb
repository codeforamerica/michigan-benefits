module Integrated
  class BuyAndPrepareFoodWithOtherPersonController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
      ]
    end

    def self.custom_skip_rule_set(application)
      if application.unstable_housing? || application.food_applying_members.count != 2
        true
      else
        false
      end
    end

    def update
      current_application.food_applying_members.second.update(params_for(:member))
      redirect_to(next_path)
    end
  end
end
