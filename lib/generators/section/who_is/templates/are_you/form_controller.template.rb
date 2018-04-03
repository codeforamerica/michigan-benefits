module Integrated
  class AreYou<%= model_name %>Controller < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      current_application.primary_member.update!(member_params)
    end
  end
end
