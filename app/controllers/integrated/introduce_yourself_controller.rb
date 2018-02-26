module Integrated
  class IntroduceYourselfController < FormsController
    def update_models
      if current_application
        current_application.primary_member.update(form_params)
      else
        application = CommonApplication.create
        application.members.create(form_params)
        session[:current_application_id] = application.id
      end
    end

    private

    def existing_attributes
      if current_application
        HashWithIndifferentAccess.new(
          current_application.primary_member.attributes,
        )
      else
        {}
      end
    end
  end
end
