require 'rails_helper'

describe SessionsController do
  before { beta_login_if_necessary }

  it "should get login" do
    get :new
    assert_response :success
  end

  it "should get logout" do
    get :destroy
    assert_response :redirect
  end

  describe '#create' do
    it 'success' do
      Account.create!(email: 'bob@example.com', password: 'password')

      post :create, {email: 'bob@example.com', password: 'password'}
      assert_response :redirect
      assert_redirected_to my_account_path
    end

    it 'failure' do
      post :create, {email: 'bob@example.com', password: 'password'}
      assert_response :success
      assert_template 'sessions/new'
    end
  end
end
