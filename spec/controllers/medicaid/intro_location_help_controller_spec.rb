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
  end
end
