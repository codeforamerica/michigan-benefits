require 'rails_helper'

describe Admin::AdminController do
  let(:account) { create :account }

  describe 'logged out' do
    it 'redirects to login' do
      get :index
      expect(response).to be_redirect
    end
  end

  describe 'not admin' do
    it 'redirects to login' do
      login_user account
      get :index
      expect(response).to be_redirect
    end
  end

  describe 'GET index' do
    before do
      account.roles << create(:admin_role)
      login_user account
    end

    it 'returns http success' do
      get :index
      expect(response).to be_success
    end
  end
end
