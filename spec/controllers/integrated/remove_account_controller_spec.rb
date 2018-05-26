require "rails_helper"

RSpec.describe Integrated::RemoveAccountController do
  describe "#update" do
    it "removes account from the application" do
      account_one = create(:account)
      account_two = create(:account)
      current_app = create(:common_application,
        members: [create(:household_member, accounts: [account_one, account_two])])

      session[:current_application_id] = current_app.id

      expect do
        put :update, params: { form: { account_id: account_two.id } }
      end.to change { current_app.accounts.count }.by(-1)
    end
  end
end
