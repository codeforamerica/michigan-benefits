module Integrated
  class AddHealthcareMemberController < AddMemberController
    def additional_model_attributes
      {
        requesting_healthcare: "yes",
      }
    end

    def overview_path
      healthcare_sections_path
    end
  end
end
