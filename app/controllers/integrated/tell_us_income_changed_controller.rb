module Integrated
  class TellUsIncomeChangedController < FormsController
    def self.custom_skip_rule_set(application)
      !application.income_changed_yes?
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
