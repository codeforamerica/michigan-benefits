module Integrated
  class SignSubmitController < FormsController
    def update_models
      current_application.update(params_for(:application).merge(signed_at: Time.current))
    end
  end
end
