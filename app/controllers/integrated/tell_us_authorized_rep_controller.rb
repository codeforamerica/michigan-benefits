module Integrated
  class TellUsAuthorizedRepController < FormsController
    def self.custom_skip_rule_set(application)
      !application.authorized_representative_yes?
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
