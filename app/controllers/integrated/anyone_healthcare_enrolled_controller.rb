module Integrated
  class AnyoneHealthcareEnrolledController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_healthcare_enrolled] == "false"
        current_application.members.update_all(healthcare_enrolled: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
