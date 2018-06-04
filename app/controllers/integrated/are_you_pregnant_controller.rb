module Integrated
  class AreYouPregnantController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.single_member_only(application)]
    end

    def update_models
      current_application.primary_member.update!(params_for(:member))
      if params_for(:member)[:pregnant] == "yes"
        current_application.navigator.update(anyone_pregnant: true)
      end
    end
  end
end
