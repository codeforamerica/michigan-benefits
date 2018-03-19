module Integrated
  class RemoveSnapMemberController < FormsController
    def update_models
      flash[:notice] = if member&.update_attributes(buy_and_prepare_food_together: "no")
                         "Removed the household member from the Food Assistance application."
                       else
                         "Could not remove household member from the Food Assistance application."
                       end
    end

    def previous_path(*_args)
      review_food_assistance_members_sections_path
    end

    def next_path
      review_food_assistance_members_sections_path
    end

    def member
      if member_params[:member_id].present?
        current_application.members.find_by(id: member_params[:member_id])
      end
    end
  end
end
