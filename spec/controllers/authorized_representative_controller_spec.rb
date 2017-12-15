require "rails_helper"

RSpec.describe AuthorizedRepresentativeController do
  describe "#next_path" do
    it "is other contact info path" do
      snap_application = create(:snap_application)
      session[:snap_application_id] = snap_application.id
      expect(subject.next_path).to eq "/steps/general-anything-else"
    end
  end

  describe "#edit" do
    context "existing member" do
      it "assigns the attributes to the step" do
        snap_application = create(:snap_application,
          authorized_representative: true,
          authorized_representative_name: "Child Face")
        session[:snap_application_id] = snap_application.id

        get :edit

        step = assigns(:step)

        expect(step.authorized_representative).to eq(true)
        expect(step.authorized_representative_name).to eq("Child Face")
      end
    end
  end

  describe "#update" do
    context "when step is valid" do
      it "redirects to next step and updates the application" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        params = {
          authorized_representative: "false",
          authorized_representative_name: "",
        }
        put :update, params: { step: params }

        snap_application.reload

        expect(response).to redirect_to(subject.next_path)
        expect(snap_application.authorized_representative).to eq(false)
        expect(snap_application.authorized_representative_name).to eq("")
      end
    end

    context "when step is invalid" do
      it "renders edit and does not update the application" do
        snap_application = create(:snap_application)
        session[:snap_application_id] = snap_application.id

        params = {
          authorized_representative: "true",
          authorized_representative_name: nil,
        }
        put :update, params: { step: params }

        snap_application.reload

        expect(response).to render_template(:edit)
        expect(snap_application.authorized_representative).to be_nil
        expect(snap_application.authorized_representative_name).to be_nil
      end
    end
  end
end
