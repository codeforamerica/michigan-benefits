module Integrated
  class AnyoneSelfEmployedController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if params_for(:navigator)[:anyone_self_employed] == "false"
        current_application.members.update_all(self_employed: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
