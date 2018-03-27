module Integrated
  class AnyoneMarriedController < FormsController
    def self.skip?(application)
      return true if application.single_member_household?
      application.navigator.anyone_married?
    end

    def update_models
      current_application.navigator.update!(navigator_params)
    end
  end
end
