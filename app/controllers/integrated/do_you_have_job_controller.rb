module Integrated
  class DoYouHaveJobController < FormsController
    def self.skip?(application)
      !application.single_member_household?
    end

    def update_models
      if navigator_params[:current_job] == "false"
        current_application.primary_member.employments.delete_all
      elsif current_application.primary_member.employments.count.zero?
        current_application.primary_member.employments.create
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
