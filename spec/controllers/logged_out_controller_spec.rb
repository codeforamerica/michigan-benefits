require 'rails_helper'

describe LoggedOutController do
  it "should get index" do
    get :index
    assert_response :success
  end
end
