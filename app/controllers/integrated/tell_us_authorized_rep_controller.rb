module Integrated
  class TellUsAuthorizedRepController < FormsController
    def self.skip?(application)
      !application.authorized_representative?
    end

    def update_models
      current_application.update(application_params)
    end
  end
end
