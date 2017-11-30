module Admin
  class SnapApplicationsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = SnapApplication.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   SnapApplication.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    def resend_email
      application = SnapApplication.find(params[:id])

      ExportFactory.create!(
        benefit_application: application,
        destination: :office_email,
        force: true,
      )

      confirmation = "Resent email to #{application.receiving_office.email}" \
                     " for #{application.signature}!"
      flash[:notice] = confirmation
      redirect_to admin_root_path
    end

    def pdf
      application = SnapApplication.find(params[:id])
      send_data(application.pdf.read,
        filename: "snap-application-#{application.signature}.pdf",
        type: "application/pdf",
        disposition: "inline")
    end
  end
end
