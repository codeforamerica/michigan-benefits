module Integrated
  class ReviewFoodAssistanceMembersController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.must_be_applying_for_food_assistance(application),
      ]
    end

    def edit
      @primary_member = current_application.primary_member
      @food_household_members = current_application.food_household_members - [current_application.primary_member]
      @non_household_members = current_application.members - current_application.food_household_members
    end

    def form_class
      NullStep
    end
  end
end
