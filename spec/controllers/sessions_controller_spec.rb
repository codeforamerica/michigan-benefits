require 'rails_helper'

describe SessionsController do
  it "should get login" do
    get :new
    assert_response :success
  end

  it "should get logout" do
    get :destroy
    assert_response :redirect
  end

  describe '#create' do
    let!(:account) { create(:account, email: 'bob@example.com', password: 'password') }

    context 'with valid login credentials' do
      before { post :create, {email: 'bob@example.com', password: 'password'} }
      it 'succeeds' do
        assert_response :redirect
        assert_redirected_to my_account_path
        expect(logged_in?).to eq(true)
      end
    end
    context 'with valid mixed-case login credentials' do
      before { post :create, {email: 'Bob@example.Com', password: 'password'} }
      it 'succeeds' do
        assert_response :redirect
        assert_redirected_to my_account_path
        expect(logged_in?).to eq(true)
      end
    end
    context 'with invalid mixed-case login credentials' do
      before { post :create, {email: 'bob@example.com', password: 'NOTTHEPASSWORD'} }
      it 'fails' do
        assert_response :success
        assert_template 'sessions/new'
        expect(flash.now[:alert]).not_to be_blank
        expect(logged_in?).to eq(false)
      end
    end
    context 'with an unknown user' do
      before { post :create, {email: 'notbob@example.com', password: 'password'} }
      it 'fails' do
        post :create, {email: 'notbob@example.com', password: 'password'}
        assert_response :success
        assert_template 'sessions/new'
        expect(flash.now[:alert]).not_to be_blank
        expect(logged_in?).to eq(false)
      end
    end
  end
end
