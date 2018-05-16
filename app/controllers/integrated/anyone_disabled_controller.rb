module Integrated
  class AnyoneDisabledController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if params_for(:navigator)[:anyone_disabled] == "false"
        current_application.members.update_all(disabled: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
