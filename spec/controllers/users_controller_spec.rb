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
    end
  end

  describe "#create", :guest do
    specify do
      process :create, method: :post, params: { user: { name: "Name", email: "email", password: "password" } }
      expect(response).to redirect_to root_path
      expect(User.last.name).to eq "Name"
      expect(User.last.email).to eq "email"
    end
  end

end
