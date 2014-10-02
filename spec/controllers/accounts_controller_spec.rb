require 'rails_helper'

describe AccountsController, type: :controller do
  before { beta_login_if_necessary }

  it "should get new" do
    get :new
    expect(response).to be_success
  end

  describe '#create' do
    it 'success' do
      post :create, {account: { email: 'bob@example.com', password: 'password' } }

      expect(Account.last.email).to eq('bob@example.com')

      expect(response).to be_redirect
    end

    it 'failure' do
      expect do 
        post :create, {account: { email: 'bob@example.com', password: 'password' } }
        post :create, {account: { email: 'bob@example.com', password: 'password' } }
      end.to change { Account.count }.by(1)

      # expect(response).to be_success

      assert_template 'accounts/new'
    end
  end
end
