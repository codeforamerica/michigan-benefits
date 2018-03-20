module Integrated
  class AddHealthcareMemberController < FormsController
    def update_models
      member_data = member_params
      combine_birthday_fields(member_data)
      member_data[:requesting_healthcare] = "yes"
      current_application.members.create(member_data)
    end

    def previous_path(*_args)
      healthcare_sections_path
    end

    def next_path
      healthcare_sections_path
    end
  end
end
