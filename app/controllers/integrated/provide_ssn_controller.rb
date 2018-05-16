module Integrated
  class ProvideSsnController < FormsController
    def update_models
      current_application.primary_member.update(params_for(:member))
    end
  end
end
