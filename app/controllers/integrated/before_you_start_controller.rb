module Integrated
  class BeforeYouStartController < FormsController
    before_action :clear_current_application, only: :edit
    skip_before_action :ensure_application_present

    def form_class
      NullStep
    end

    private

    def clear_current_application
      session[:current_application_id] = nil
    end
  end
end
