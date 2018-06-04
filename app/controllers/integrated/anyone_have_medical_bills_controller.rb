module Integrated
  class AnyoneHaveMedicalBillsController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def update_models
      if params_for(:navigator)[:anyone_medical_bills] == "false"
        current_application.members.update_all(medical_bills: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
