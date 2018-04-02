module Integrated
  class AnyoneFosterCareController < FormsController
    def self.skip?(application)
      return true if application.single_member_household?
      application.members.map(&:age).compact.each do |age|
        return false if age >= 18 && age <= 26
      end
      true
    end

    def update_models
      if navigator_params[:anyone_foster_care_at_18] == "false"
        current_application.members.update_all(foster_care_at_18: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
