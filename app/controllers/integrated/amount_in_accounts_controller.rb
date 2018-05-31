module Integrated
  class AmountInAccountsController < FormsController
    def self.custom_skip_rule_set(application)
      !application.navigator.money_in_accounts?
    end

    def update_models
      current_application.update!(params_for(:application))
    end
  end
end
