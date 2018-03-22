module Integrated
  class RemoveTaxMemberController < RemoveMemberController
    def update_models
      flash[:notice] = if member&.update_attributes(tax_relationship: "not_included")
                         "Removed the household member from your tax household."
                       else
                         "Could not remove the household member from your tax household."
                       end
    end

    def overview_path
      review_tax_relationships_sections_path
    end
  end
end
