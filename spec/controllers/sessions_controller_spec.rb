require "rails_helper"

describe SessionsController do
  describe "routing" do
    specify do
      expect(delete: "/sessions").to route_to "sessions#destroy"
    end
  end

  describe "#destroy" do
    specify do
      login_user create(:user)

      expect {
        delete :destroy
      }.to change { logged_in? }.from(true).to(false)
      expect(response).to redirect_to root_path
    end
  end
end
