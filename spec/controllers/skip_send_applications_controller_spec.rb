require "rails_helper"

RSpec.describe SkipSendApplicationsController do
  describe "#create" do
    context "without current application" do
      let(:current_app) { create(:snap_application) }
      before { session[:snap_application_id] = current_app.id }

      it "redirects to home page with sorry message" do
        post :create

        expect(response).to redirect_to(root_path(anchor: "fold"))
        expect(flash[:notice]).to include("submitted")
      end
    end

    context "with current application" do
      it "redirects to home page with success message" do
        post :create

        expect(response).to redirect_to(root_path(anchor: "fold"))
        expect(flash[:notice]).to include("Sorry")
      end
    end
  end
end
