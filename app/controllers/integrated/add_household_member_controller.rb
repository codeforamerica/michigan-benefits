module Integrated
  class AddHouseholdMemberController < FormsController
    def update_models
      current_application.members.create(member_params)
    end

    def previous_path(*_args)
      household_members_overview_sections_path
    end

    def next_path
      household_members_overview_sections_path
    end
  end
end
