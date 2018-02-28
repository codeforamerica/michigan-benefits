module Integrated
  class IntroduceYourselfController < FormsController
    skip_before_action :ensure_application_present

    def update_models
      if current_application
        current_application.primary_member.update(member_params)
        current_application.update(application_params)
      else
        application = CommonApplication.create(application_params)
        application.members.create(member_params)
        session[:current_application_id] = application.id
      end
    end

    private

    def member_params
      form_params.except(*form_class.application_attributes)
    end

    def application_params
      form_params.slice(*form_class.application_attributes)
    end

    def existing_attributes
      if current_application
        attributes = current_application.attributes.
          merge(current_application.primary_member.attributes)
        HashWithIndifferentAccess.new(attributes)
      else
        {}
      end
    end
  end
end
