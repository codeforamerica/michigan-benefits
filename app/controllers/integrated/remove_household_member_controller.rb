module Integrated
  class RemoveHouseholdMemberController < FormsController
    def update_models
      flash[:notice] = if member && current_application.members.delete(member)
                         "Removed the household member."
                       else
                         "Could not remove household member."
                       end
    end

    def previous_path(*_args)
      household_members_overview_sections_path
    end

    def next_path
      household_members_overview_sections_path
    end

    def member
      if member_params[:member_id].present?
        current_application.members.find_by(id: member_params[:member_id])
      end
    end
  end
end
