require "rails_helper"

RSpec.describe OfficeLocationController do
  describe "#edit" do
    context "office page present on application" do
      it "skips to the next step" do
        snap_application = create(:snap_application, office_page: "clio")
        session[:snap_application_id] = snap_application.id

        get :edit

        expect(response).to redirect_to(controller.next_path)
      end
    end

    context "office page not present on application" do
      it "assigns the location to the step" do
        snap_application = create(:snap_application,
          office_page: nil,
          selected_office_location: "clio")
        session[:snap_application_id] = snap_application.id

        get :edit

        step = assigns(:step)

        expect(step.selected_office_location).to eq("clio")
      end
    end
  end

  describe "#update" do
    context "when step is valid" do
      it "redirects to next step and updates the application" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        params = {
          selected_office_location: "clio",
        }
        put :update, params: { step: params }

        snap_application.reload

        expect(response).to redirect_to(subject.next_path)
        expect(snap_application.selected_office_location).to eq("clio")
      end
    end
  end
end
