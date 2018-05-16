module Integrated
  class AreYouPregnantController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
      if params_for(:member)[:pregnant] == "yes"
        current_application.navigator.update(anyone_pregnant: true)
      end
    end
  end
end
