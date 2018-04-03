module Integrated
  class Anyone<%= model_name %>Controller < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_<%= model_method %>] == "false"
        current_application.members.update_all(<%= model_method %>: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
