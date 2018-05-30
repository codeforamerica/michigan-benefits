module Integrated
  class AnyoneCaretakerController < FormsController
    def self.skip_rule_sets(application)
      [
        SkipRules.multi_member_only(application),
        SkipRules.must_be_applying_for_healthcare(application),
      ]
    end

    def update_models
      current_application.navigator.update!(params_for(:navigator))
    end
  end
end
