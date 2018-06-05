require "rails_helper"

RSpec.describe Integrated::VehiclesOverviewController do
  describe "#skip?" do
    context "when no one owns a vehicle" do
      it "returns true" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, requesting_food: "yes"),
                             navigator: build(:application_navigator, own_vehicles: false))

        skip_step = Integrated::VehiclesOverviewController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end

    context "when someone owns a vehicle" do
      it "returns false" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, requesting_food: "yes"),
                             navigator: build(:application_navigator, own_vehicles: true))

        skip_step = Integrated::VehiclesOverviewController.skip?(application)
        expect(skip_step).to eq(false)
      end
    end
  end
end
