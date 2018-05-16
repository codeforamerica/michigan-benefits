module Integrated
  class AnyoneStudentController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if params_for(:navigator)[:anyone_student] == "false"
        current_application.members.update_all(student: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
