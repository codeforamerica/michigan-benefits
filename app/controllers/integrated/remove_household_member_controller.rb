module Integrated
  class RemoveHouseholdMemberController < RemoveMemberController
    def update_models
      flash[:notice] = if member && current_application.members.delete(member)
                         "Removed the household member."
                       else
                         "Could not remove household member."
                       end
    end

    def overview_path
      household_members_overview_sections_path
    end
  end
end
