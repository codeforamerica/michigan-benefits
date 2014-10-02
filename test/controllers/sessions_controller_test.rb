require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get login" do
    get :new
    assert_response :success
  end

  test "should get logout" do
    get :destroy
    assert_response :redirect
  end

end
