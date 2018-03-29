module Integrated
  class AnyoneStudentController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_student] == "false"
        current_application.members.update_all(student: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
