module Integrated
  class AreYouCitizenController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.primary_member.update!(member_params)
      if member_params[:citizen] == "yes"
        current_application.navigator.update(everyone_citizen: true)
      end
    end
  end
end
