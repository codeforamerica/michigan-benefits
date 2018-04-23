require "rails_helper"

RSpec.describe Integrated::MoneyInAccountsController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          money_in_accounts: "true",
        }
      end

      it "updates the navigator" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.money_in_accounts).to eq(true)
      end
    end
  end
end
