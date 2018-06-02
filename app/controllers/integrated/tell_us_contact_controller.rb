module Integrated
  class TellUsContactController < FormsController
    def self.skip?(application)
      application.sms_consented_no? && application.email_consented_no?
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
