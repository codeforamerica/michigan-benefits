module Integrated
  class DoYouHaveJobController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.navigator.update(navigator_params)
    end
  end
end
