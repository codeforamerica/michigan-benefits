require "rails_helper"

RSpec.describe Medicaid::IntroLocationController do
  describe "#edit" do
    context "application has not yet been created" do
      it "does not redirect" do
        session[:medicaid_application_id] = nil

        get :edit

        expect(response).to render_template(:edit)
      end

      context "with office location get param" do
        it "updates the office location and stores app in the session" do
          get :edit, params: { office_location: "my office" }

          app = MedicaidApplication.last

          expect(app.office_location).to eq("my office")
          expect(session[:medicaid_application_id]).to eq(app.id)
        end
      end
    end

    context "with existing application" do
      context "with office location get param" do
        it "updates the office location" do
          medicaid_application = create(:medicaid_application)
          session[:medicaid_application_id] = medicaid_application.id

          get :edit, params: { office_location: "my office" }

          medicaid_application.reload

          expect(medicaid_application.office_location).to eq("my office")
        end
      end

      context "with empty param" do
        it "does not delete existing location" do
          medicaid_application = create(
            :medicaid_application,
            office_location: "bajora",
          )
          session[:medicaid_application_id] = medicaid_application.id

          get :edit

          medicaid_application.reload

          expect(medicaid_application.office_location).to eq("bajora")
        end
      end
    end
  end
end
