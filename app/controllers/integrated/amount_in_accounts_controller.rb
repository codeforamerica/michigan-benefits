module Integrated
  class AmountInAccountsController < FormsController
    def self.skip?(application)
      !application.navigator.money_in_accounts?
    end

    def update_models
      current_application.update!(params_for(:application))
    end
  end
end
