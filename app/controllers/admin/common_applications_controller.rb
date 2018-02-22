module Admin
  class CommonApplicationsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = CommonApplication.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   CommonApplication.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def pdf
      application = CommonApplication.find(params[:id])
      send_data(application.pdf.read,
                filename: "common-application-#{application.primary_member.display_name}.pdf",
                type: "application/pdf",
                disposition: "inline")
    end
  end
end
