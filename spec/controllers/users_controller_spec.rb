# frozen_string_literal: true

require "rails_helper"

describe UsersController do
  describe "routing" do
    specify do
      expect(get: "/users/new").to route_to "users#new"
      expect(post: "/users").to route_to "users#create"
    end
  end

  describe "#new", :guest do
    specify do
      get :new
      expect(response.code).to eq "200"
      expect(assigns[:user]).to be_new_record
    end

    context "ENV has disabled sign-ups" do
      before do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("SIGNUPS_DISABLED").and_return("true")
      end

      it "prevents sign-ups" do
        get :new

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Sorry, sign-ups are temporarily disabled")
      end
    end
  end

  describe "#create", :guest do
    specify do
      post :create, params: {}
      expect(response).to redirect_to step_path("introduction-introduce-yourself")
      expect(User.last.name).to be_present
      expect(User.last.email).to match /\w*@example.com/
      expect(User.last.crypted_password).to be_present
    end

    context "ENV has disabled sign-ups" do
      before do
        allow(ENV).to receive(:[]).and_return(nil)
        allow(ENV).to receive(:[]).with("SIGNUPS_DISABLED").and_return("true")
      end

      it "prevents sign-ups" do
        post :create, params: { user: { name: "Name", email: "email", password: "password" } }

        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Sorry, sign-ups are temporarily disabled")
      end
    end
  end
end
