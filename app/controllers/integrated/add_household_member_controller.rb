module Integrated
  class AddHouseholdMemberController < FormsController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      current_application.members.create(member_data)
    end

    def previous_path(*_args)
      household_members_overview_sections_path
    end

    def next_path
      household_members_overview_sections_path
    end
  end
end
