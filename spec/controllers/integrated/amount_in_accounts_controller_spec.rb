require "rails_helper"

RSpec.describe Integrated::AmountInAccountsController do
  describe "#skip?" do
    context "when applicant does have money in accounts but is not requesting food assistance" do
      it "returns true" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, requesting_food: "no"),
                             navigator: build(:application_navigator, money_in_accounts: true))

        skip_step = Integrated::AmountInAccountsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when applicant does not have money in accounts" do
      it "returns true" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, requesting_food: "yes"),
                             navigator: build(:application_navigator, money_in_accounts: false))

        skip_step = Integrated::AmountInAccountsController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          less_than_threshold_in_accounts: "yes",
        }
      end

      it "updates the models" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, money_in_accounts: true))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.less_than_threshold_in_accounts_yes?).to be_truthy
      end
    end
  end
end
