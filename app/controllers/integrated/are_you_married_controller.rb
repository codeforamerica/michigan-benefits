module Integrated
  class AreYouMarriedController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.primary_member.update(member_params)
      if member_params[:married] == "yes"
        current_application.navigator.update(anyone_married: true)
      end
    end
  end
end
