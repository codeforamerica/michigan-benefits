require "rails_helper"

RSpec.describe Integrated::AccountsOverviewController do
  describe "#skip?" do
    context "when no one has more than the threshold in their accounts" do
      it "returns true" do
        application = create(:common_application, less_than_threshold_in_accounts: "yes")

        skip_step = Integrated::AccountsOverviewController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when we don't know if anyone has more than the threshold in their accounts" do
      it "returns true" do
        application = create(:common_application, less_than_threshold_in_accounts: "unfilled")

        skip_step = Integrated::AccountsOverviewController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when someone has more than the threshold in their accounts" do
      it "returns false" do
        application = create(:common_application, less_than_threshold_in_accounts: "no")

        skip_step = Integrated::AccountsOverviewController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end
end
