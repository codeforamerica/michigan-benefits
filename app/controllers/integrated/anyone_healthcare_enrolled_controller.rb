module Integrated
  class AnyoneHealthcareEnrolledController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def update_models
      if params_for(:navigator)[:anyone_healthcare_enrolled] == "false"
        current_application.members.update_all(healthcare_enrolled: "no")
      end

      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
