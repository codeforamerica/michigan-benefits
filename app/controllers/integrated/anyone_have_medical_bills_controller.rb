module Integrated
  class AnyoneHaveMedicalBillsController < FormsController
    def self.skip?(application)
      application.single_member_household?
    end

    def update_models
      if params_for(:navigator)[:anyone_medical_bills] == "false"
        current_application.members.update_all(medical_bills: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
