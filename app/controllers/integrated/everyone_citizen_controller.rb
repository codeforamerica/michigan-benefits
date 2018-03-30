module Integrated
  class EveryoneCitizenController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:everyone_citizen] == "true"
        current_application.members.update_all(citizen: "yes")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
