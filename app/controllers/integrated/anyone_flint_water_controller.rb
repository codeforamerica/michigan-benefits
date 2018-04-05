module Integrated
  class AnyoneFlintWaterController < FormsController
    def self.skip?(application)
      return true if application.single_member_household?
      members = application.members
      no_skip = members.any?(&:pregnant_yes?) || members.any?(&:pregnancy_expenses_yes?) ||
        members.any? { |member| member.age.nil? || (member.age && member.age < 21) }
      no_skip ? false : true
    end

    def update_models
      if navigator_params[:anyone_flint_water] == "false"
        current_application.members.update_all(flint_water: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
