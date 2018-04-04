module Integrated
  class AnyonePregnantController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_pregnant] == "false"
        current_application.members.update_all(pregnant: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
