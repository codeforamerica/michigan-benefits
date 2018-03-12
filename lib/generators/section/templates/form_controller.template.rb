module Integrated
  class <%= model.camelcase %>Controller < FormsController
    <%- if options.doc? -%>
    # If updating models, uncomment the following and modify required logic:
    #
    #   def update_models
    #     current_application.primary_member.update(member_params)
    #     current_application.update(application_params)
    #   end
    #
    # If no database update is needed, uncomment the following `form_class` method
    # to override the form class (otherwise form class will
    # default to <%= model.underscore %>Form):
    #
    #   def form_class
    #     NullStep
    #   end
    <%- end -%>
  end
end
