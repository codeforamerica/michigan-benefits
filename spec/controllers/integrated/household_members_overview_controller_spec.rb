require "rails_helper"

RSpec.describe Integrated::HouseholdMembersOverviewController do
  describe "#skip?" do
    context "Medicaid-only flow" do
      it "returns true" do
        application = create(:common_application,
                             navigator: build(:application_navigator, applying_for_healthcare: true))

        skip_step = Integrated::HouseholdMembersOverviewController.skip?(application)
        expect(skip_step).to be_truthy
      end
    end

    context "SNAP flow" do
      it "returns false" do
        application = create(:common_application,
                             navigator: build(:application_navigator,
                                              applying_for_food: true,
                                              applying_for_healthcare: false))

        skip_step = Integrated::HouseholdMembersOverviewController.skip?(application)
        expect(skip_step).to be_falsey
      end
    end
  end
end
