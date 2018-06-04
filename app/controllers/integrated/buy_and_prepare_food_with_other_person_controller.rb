module Integrated
  class BuyAndPrepareFoodWithOtherPersonController < FormsController
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
