require "rails_helper"

RSpec.describe Integrated::OfficeLocationController do
  describe "#skip" do
    context "office page present on application" do
      it "returns true" do
        application = create(:common_application, office_page: "clio")

        skip_step = Integrated::OfficeLocationController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "office page not present on application" do
      it "returns false" do
        application = create(:common_application, office_page: nil)

        skip_step = Integrated::OfficeLocationController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end

  describe "edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
                             selected_office_location: "clio")
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.selected_office_location).to eq("clio")
      end
    end
  end

  describe "#update" do
    it "redirects to next path and updates the application" do
      current_app = create(:common_application)
      session[:current_application_id] = current_app.id

      params = {
        selected_office_location: "clio",
      }
      put :update, params: { form: params }

      current_app.reload

      expect(response).to redirect_to(subject.next_path)
      expect(current_app.selected_office_location).to eq("clio")
    end
  end
end
