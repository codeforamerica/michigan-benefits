module Integrated
  class AddMemberController < FormsController
    helper_method :valid_relationship_options, :valid_relationship_options_for_taxes

    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def form_class
      AddMemberForm
    end

    def update_models
      member_data = combined_attributes(member_params)
      if member_data[:relationship] == "spouse"
        member_data[:married] = "yes"
        current_application.navigator.update!(anyone_married: true)
        current_application.primary_member.update!(married: "yes")
      end
      current_application.members.create!(member_data)
    end

    def valid_relationship_options
      if current_application.members.any?(&:is_spouse?)
        HouseholdMember::RELATIONSHIP_LABELS_AND_KEYS.reject { |arr| arr.second == "spouse" }
      else
        HouseholdMember::RELATIONSHIP_LABELS_AND_KEYS
      end
    end

    def valid_relationship_options_for_taxes
      options_for_taxes = valid_relationship_options
      options_for_taxes.each do |option|
        case option[0]
        when "Choose one"
          option # do nothing
        when "Spouse"
          option << { "data-follow-up": "#spouse-follow-up" }
        else
          option << { "data-follow-up": "#nonspouse-follow-up" }
        end
        options_for_taxes
      end
    end

    private

    def combined_attributes(existing_params)
      modified_member_data = existing_params.merge(
        combined_birthday_fields(
          day: existing_params.delete("birthday_day"),
          month: existing_params.delete("birthday_month"),
          year: existing_params.delete("birthday_year"),
        ),
      )
      modified_member_data.merge(additional_model_attributes)
    end

    def additional_model_attributes
      {}
    end
  end
end
