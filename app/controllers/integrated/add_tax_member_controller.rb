module Integrated
  class AddTaxMemberController < AddMemberController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      member_data[:requesting_healthcare] = "yes"
      current_application.members.create(member_data)
    end

    def overview_path
      review_tax_relationships_sections_path
    end

    def form_class
      AddTaxMemberForm
    end
  end
end
