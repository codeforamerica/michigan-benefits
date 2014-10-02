require 'test_helper'

describe AccountsController do
  it "should get new" do
    get :new
    assert_response :success
  end

  describe '#create' do
    it 'success' do
      post :create, {account: { email: 'bob@example.com', password: 'password' } }

      Account.last.email.must_equal 'bob@example.com'

      assert_response :redirect
    end

    it 'failure' do
      initial_count = Account.count
      post :create, {account: { email: 'bob@example.com', password: 'password' } }
      Account.count.must_equal initial_count + 1

      post :create, {account: { email: 'bob@example.com', password: 'password' } }
      Account.count.must_equal initial_count + 1

      assert_response :success

      assert_template 'accounts/new'
    end
  end
end
