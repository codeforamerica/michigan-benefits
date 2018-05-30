module Integrated
  class DoYouHaveMedicalBillsController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.single_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
    end
  end
end
