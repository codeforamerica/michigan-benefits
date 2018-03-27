module Integrated
  class AddHouseholdMemberController < AddMemberController
    def overview_path
      household_members_overview_sections_path
    end
  end
end
