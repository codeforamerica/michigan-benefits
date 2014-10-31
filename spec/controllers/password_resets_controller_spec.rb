require 'rails_helper'

describe PasswordResetsController do
  describe "new" do
    it "is successful" do
      get :new
      assert_response :success
    end
  end

  describe "create" do
    it "is successful" do
      create(:account, email: 'bob@example.com')
      expect(AccountsMailer).to receive(:reset_password_email).and_call_original
      post :create, {email: 'bob@example.com'}
      assert_response :redirect
      expect(flash[:notice]).to be
      assert_redirected_to root_path
    end

    it "says it is successful even if account cannot be found" do
      expect(AccountsMailer).not_to receive(:reset_password_email)
      post :create, {email: 'bob@example.com'}
      assert_response :redirect
      expect(flash[:notice]).to be
      assert_redirected_to root_path
    end
  end

  describe "edit" do
    it "is successful" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      get :edit, id: account.reset_password_token
      assert_response :success
      expect(assigns[:account]).to eq account
      expect(assigns[:token]).to eq account.reset_password_token
    end

    it "fails if account cannot be found" do
      get :edit, id: 'not-a-valid-reset-token'
      assert_response :redirect
      assert_redirected_to new_session_path
    end
  end

  describe "update" do
    it "is successful" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      put :update, id: account.reset_password_token, account: { password: mom.valid_password + "1" }
      assert_response :redirect
      assert_redirected_to my_account_path
      expect(flash[:notice]).to be
      expect(controller.send(:logged_in?)).to be true
    end

    it "fails if account cannot be found" do
      put :update, id:  'not-a-valid-reset-token', account: { password: mom.valid_password + "1" }
      assert_response :redirect
      assert_redirected_to new_session_path
    end

    it "fails if password is invalid" do
      account = create(:account)
      account.deliver_reset_password_instructions!
      put :update, id: account.reset_password_token, account: { password: "" }
      assert_template :edit
      expect(assigns[:account]).to eq account
      expect(assigns[:token]).to eq account.reset_password_token
    end

    context "with link expiry" do
      it "works if link was created less than 12 hours ago" do
        account = create(:account)
        account.deliver_reset_password_instructions!
        travel_to (11.hours + 59.minutes).from_now do
          put :update, id: account.reset_password_token, account: { password: mom.valid_password + "1" }
        end
        assert_response :redirect
        assert_redirected_to my_account_path
      end

      it "does not work if link was created more than 12 hours ago" do
        account = create(:account)
        account.deliver_reset_password_instructions!
        travel_to 12.hours.from_now do
          put :update, id: account.reset_password_token, account: { password: mom.valid_password + "1" }
        end
        assert_response :redirect
        assert_redirected_to new_session_path
      end
    end
  end
end
