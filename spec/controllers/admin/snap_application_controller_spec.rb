require "rails_helper"

RSpec.describe Admin::SnapApplicationsController do
  describe "#index" do
    it "returns error with no proper authentication" do
      get :index

      expect(response.status).to eq 401
    end

    context "performing a search" do
      it "returns successfully" do
        create(:snap_application, signature: "Joel Tester")

        request.env["HTTP_AUTHORIZATION"] =
          ActionController::HttpAuthentication::Basic.encode_credentials(
            "admin",
            "password",
          )

        get :index, params: { search: "Joel" }

        expect(response.status).to eq 200
      end
    end
  end
end
