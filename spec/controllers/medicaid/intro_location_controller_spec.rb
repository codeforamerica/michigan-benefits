require "rails_helper"

RSpec.describe Medicaid::IntroLocationController do
  describe "#edit" do
    context "application has not yet been created" do
      it "does not redirect" do
        session[:medicaid_application_id] = nil

        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
