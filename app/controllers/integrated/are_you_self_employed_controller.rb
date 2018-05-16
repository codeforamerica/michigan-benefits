module Integrated
  class AreYouSelfEmployedController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
