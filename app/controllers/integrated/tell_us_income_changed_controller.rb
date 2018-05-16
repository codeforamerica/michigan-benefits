module Integrated
  class TellUsIncomeChangedController < FormsController
    def self.skip?(application)
      !application.income_changed_yes?
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
