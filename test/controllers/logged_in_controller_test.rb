require 'test_helper'

class LoggedInControllerTest < ActionController::TestCase
  test "should get landing" do
    get :landing
    assert_response :success
  end

end
