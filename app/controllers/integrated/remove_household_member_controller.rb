module Integrated
  class RemoveHouseholdMemberController < RemoveMemberController
    def update_models
      if member.is_spouse?
        current_application.primary_member.update!(married: "no")

        if (current_application.members - [member]).none?(&:married_yes?)
          current_application.navigator.update!(anyone_married: false)
        end
      end

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
