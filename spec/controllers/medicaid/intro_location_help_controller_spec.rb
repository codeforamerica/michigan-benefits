require "rails_helper"

RSpec.describe Medicaid::IntroLocationHelpController do
  describe "#edit" do
    context "application has not yet been created" do
      it "redirects to intro location page" do
        session[:medicaid_application_id] = nil

        get :edit

        expect(response).to redirect_to("/steps/medicaid/intro-location")
      end
    end

    context "client is michigan resident" do
      it "redirects to next step" do
        medicaid_application =
          create(:medicaid_application, michigan_resident: true)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to redirect_to("/steps/medicaid/intro-name")
      end
    end

    context "client is not a michigan resident" do
      it "renders edit" do
        medicaid_application =
          create(:medicaid_application, michigan_resident: false)
        session[:medicaid_application_id] = medicaid_application.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
