module Integrated
  class AnyoneSelfEmployedController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_self_employed] == "false"
        current_application.members.update_all(self_employed: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
