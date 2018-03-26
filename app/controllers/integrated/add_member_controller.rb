module Integrated
  class AddMemberController < FormsController
    helper_method :valid_relationship_options

    def previous_path(*_args)
      overview_path
    end

    def next_path
      overview_path
    end

    def form_class
      AddMemberForm
    end

    def valid_relationship_options
      if current_application.members.any?(&:is_spouse?)
        HouseholdMember::RELATIONSHIP_LABELS_AND_KEYS.reject { |arr| arr.second == "spouse" }
      else
        HouseholdMember::RELATIONSHIP_LABELS_AND_KEYS
      end
    end
  end
end
