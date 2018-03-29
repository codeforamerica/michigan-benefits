module Integrated
  class AddTaxMemberController < AddMemberController
    def additional_model_attributes
      {
        requesting_healthcare: "yes",
      }
    end

    def update_models
      member_data = combined_attributes(member_params)
      if member_data[:relationship] == "spouse"
        member_data[:married] = "yes"
        current_application.navigator.update!(anyone_married: true)
        current_application.primary_member.update!(married: "yes")
        member_data[:tax_relationship] = member_data[:tax_relationship_spouse]
      end
      member_data.delete(:tax_relationship_spouse)
      current_application.members.create!(member_data)
    end

    def overview_path
      review_tax_relationships_sections_path
    end

    def form_class
      AddTaxMemberForm
    end
  end
end
