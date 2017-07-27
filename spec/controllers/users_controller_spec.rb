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
  end

  describe "#create", :guest do
    specify do
      post :create, params: {}
      expect(response).to redirect_to step_path("personal-detail")
      expect(User.last.name).to be_present
      expect(User.last.email).to match(/\w*@example.com/)
      expect(User.last.crypted_password).to be_present
    end
  end
end
