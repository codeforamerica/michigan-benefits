module Integrated
  class AddFoodMemberController < AddMemberController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      member_data[:requesting_food] = "yes"
      member_data[:buy_and_prepare_food_together] = "yes"
      current_application.members.create(member_data)
    end

    def overview_path
      review_food_assistance_members_sections_path
    end
  end
end
