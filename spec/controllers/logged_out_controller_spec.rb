require 'rails_helper'

describe LoggedOutController do
  before { beta_login_if_necessary }

  it "should get index" do
    get :index
    assert_response :success
  end
end
