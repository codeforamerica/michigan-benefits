module Integrated
  class AddTaxMemberController < AddMemberController
    def overview_path
      review_tax_household_sections_path
    end
  end
end
