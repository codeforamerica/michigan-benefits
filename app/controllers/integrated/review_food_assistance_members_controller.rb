module Integrated
  class ReviewFoodAssistanceMembersController < FormsController
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
