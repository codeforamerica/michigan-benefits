module Integrated
  class AddTaxMemberController < AddMemberController
    def additional_model_attributes
      {
        requesting_healthcare: "yes",
      }
    end

    def overview_path
      review_tax_relationships_sections_path
    end

    def form_class
      AddTaxMemberForm
    end
  end
end
