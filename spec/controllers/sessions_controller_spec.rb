require "rails_helper"

describe SessionsController do
  describe "routing" do
    specify do
      expect(get: "/sessions/new").to route_to "sessions#new"
      expect(post: "/sessions").to route_to "sessions#create"
      expect(delete: "/sessions").to route_to "sessions#destroy"
    end
  end

  describe "#new" do
    specify do
      get :new
      expect(response.code).to eq "200"
    end
  end

  describe "#create" do
    let!(:user) { create :user, "user" }

    specify "success case" do
      expect {
        post :create, params: { session: { email: "user@example.com", password: "password" } }
      }.to change { controller.current_user }.from(nil).to(user)

      expect(response).to redirect_to root_path
    end

    specify "failure case" do
      expect {
        post :create, params: { session: { email: "nonexistant@example.com", password: "flub" } }
      }.not_to change { controller.current_user }

      expect(logged_in?).to eq false
    end
  end

  describe "#destroy", :member do
    specify do
      expect {
        delete :destroy
      }.to change { logged_in? }.from(true).to(false)
      expect(response).to redirect_to root_path
    end
  end
end
