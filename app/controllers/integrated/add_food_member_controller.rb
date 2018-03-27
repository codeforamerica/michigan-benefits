module Integrated
  class AddFoodMemberController < AddMemberController
    def additional_model_attributes
      {
        requesting_food: "yes",
        buy_and_prepare_food_together: "yes",
      }
    end

    def overview_path
      review_food_assistance_members_sections_path
    end
  end
end
