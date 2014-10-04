require 'rails_helper'

describe LoggedInController do
  it "should get landing" do
    login_user Account.create!(email: 'bob@example.com', password: 'password')
    get :landing
    assert_response :success
  end
end
