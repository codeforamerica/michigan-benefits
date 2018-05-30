module Integrated
  class IncludeAnyoneElseOnTaxesController < FormsController
    def self.skip_rule_sets(application)
      [SkipRules.multi_member_only(application)]
    end

    def self.custom_skip_rule_set(application)
      application.primary_member.requesting_healthcare_no? ||
        application.primary_member.filing_taxes_next_year_no?
    end

    def update_models
      current_application.navigator.update(params_for(:navigator))
    end
  end
end
