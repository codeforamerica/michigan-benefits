module Integrated
  class RemoveFoodMemberController < RemoveMemberController
    def update_models
      flash[:notice] = if member&.update_attributes(buy_and_prepare_food_together: "no")
                         "Removed the household member from the Food Assistance application."
                       else
                         "Could not remove household member from the Food Assistance application."
                       end
    end

    def overview_path
      review_food_assistance_members_sections_path
    end
  end
end
