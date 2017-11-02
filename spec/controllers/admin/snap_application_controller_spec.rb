require "rails_helper"

RSpec.describe Admin::SnapApplicationsController do
  describe "#index" do
    context "not authenticated" do
      it "redirects to auth page" do
        get :index

        expect(response.status).to eq 302
      end
    end

    context "authenticated" do
      it "returns successfully" do
        admin_user = create(:admin_user)
        sign_in(admin_user)

        get :index, params: { search: "Joel" }

        expect(response.status).to eq 200
      end
    end
  end
end
