module Integrated
  class RemoveHealthcareMemberController < RemoveMemberController
    def update_models
      flash[:notice] = if remove_member
                         "Removed the member from your household."
                       else
                         "Could not remove the member from your household."
                       end
    end

    def overview_path
      review_healthcare_household_sections_path
    end

    private

    def remove_member
      if current_application.primary_member.filing_taxes_next_year_no? &&
          !current_application.navigator.applying_for_food?
        member&.destroy
      else
        member&.update_attributes(tax_relationship: "not_included")
      end
    end
  end
end
