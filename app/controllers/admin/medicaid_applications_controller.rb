module Admin
  class MedicaidApplicationsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = MedicaidApplication.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   MedicaidApplication.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def pdf
      application = MedicaidApplication.find(params[:id])
      send_data(application.pdf.read,
                filename: "medicaid-application-#{application.signature}.pdf",
                type: "application/pdf",
                disposition: "inline")
    end
  end
end
