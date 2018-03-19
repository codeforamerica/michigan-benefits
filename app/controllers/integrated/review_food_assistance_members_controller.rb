module Integrated
  class ReviewFoodAssistanceMembersController < FormsController
    def edit
      @primary_member = current_application.primary_member
      @snap_household_members = current_application.snap_household_members - [current_application.primary_member]
      @non_household_members = current_application.members - current_application.snap_household_members
    end

    def form_class
      NullStep
    end
  end
end
