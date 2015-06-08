require 'rails_helper'

describe AccountsController, type: :controller do
  before { allow(Rails.application.config).to receive(:allow_signup) { true } }

  it 'should get new' do
    get :new
    expect(response).to be_success
    assert_template 'layouts/logged_out'
  end

  describe '#create' do
    it 'success' do
      post :create, {account: { email: 'bob@example.com', password: 'password' } }

      expect(Account.last.email).to eq('bob@example.com')

      expect(response).to redirect_to my_account_path
    end

    it 'failure' do
      expect do
        post :create, {account: { email: 'bob@example.com', password: 'password' } }
        post :create, {account: { email: 'bob@example.com', password: 'password' } }
      end.to change { Account.count }.by(1)

      # expect(response).to be_success

      assert_template 'accounts/new'
      assert_template 'layouts/logged_out'
    end

    it "fails if account creation is not allowed" do
      expect(Rails.application.config).to receive(:allow_signup) { false }

      expect {
        post :create, {account: { email: 'bob@example.com', password: 'password' } }
      }.to_not change { Account.count }

      expect(response).to redirect_to new_session_path
    end
  end

  describe "edit" do
    context "logged out" do
      it "fails" do
        account = create(:account)
        get :edit, id: account
        expect(response).to redirect_to new_session_path
      end
    end

    context "logged in" do
      let(:account) { create(:account) }
      before { login_user(account) }

      it "succeeds" do
        get :edit, id: account
        expect(assigns[:account]).to eq account
        expect(response.code).to eq "200"
      end

      it "rejects other accounts" do
        get :edit, id: create(:account)
        expect(response).to redirect_to new_session_path
      end
    end
  end

  describe '#update' do
    context "logged out" do
      it "fails" do
        account = create(:account, email: "innocent@example.com", password: "goodpass")
        put :update, id: account, account: { old_password: "goodpass", password: "hackpass" }
        expect(response).to redirect_to new_session_path
        expect(Account.authenticate("innocent@example.com", "goodpass")).to eq account
      end
    end

    context "logged in" do
      let(:account) {
        create(:account, email: "carl@example.com", password: "oldpass")
      }
      before { login_user(account) }

      it 'success' do
        put :update, id: account, account: { old_password: "oldpass", password: "newpass" }
        expect(response).to redirect_to my_account_path
        expect(flash[:notice]).to be
        expect(Account.authenticate("carl@example.com", "newpass")).to eq account
      end

      it 'failure when old password is wrong' do
        put :update, id: account, account: { old_password: "badpass", password: "newpass" }

        assert_template "edit"
        expect(assigns[:account]).to eq account
        expect(flash[:alert]).to be
        expect(Account.authenticate("carl@example.com", "oldpass")).to eq account
      end

      it 'failure when new password is invalid' do
        put :update, id: account, account: { old_password: "oldpass", password: "" }

        assert_template "edit"
        expect(assigns[:account]).to eq account
        expect(flash[:alert]).to be nil
        expect(Account.authenticate("carl@example.com", "oldpass")).to eq account
      end

      it "rejects other accounts" do
        other_account = create(:account, email: "another-carl@example.com", password: "oldpass")
        put :update, id: other_account, account: { old_password: "oldpass", password: "new_account" }

        expect(response).to redirect_to new_session_path
      end
    end
  end
end
