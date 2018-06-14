module Integrated
  class AddHealthcareMemberController < AddMemberController
    def overview_path
      review_healthcare_household_sections_path
    end
  end
end
