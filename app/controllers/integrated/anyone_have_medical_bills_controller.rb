module Integrated
  class AnyoneHaveMedicalBillsController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if navigator_params[:anyone_medical_bills] == "false"
        current_application.members.update_all(medical_bills: "no")
      end

      current_application.navigator.update!(navigator_params)
    end
  end
end
