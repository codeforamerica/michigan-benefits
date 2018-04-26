module Integrated
  class SignSubmitController < FormsController
    def update_models
      current_application.update(application_params.merge(signed_at: Time.current))
    end
  end
end
