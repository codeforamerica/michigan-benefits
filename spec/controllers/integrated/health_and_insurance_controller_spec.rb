require "rails_helper"

RSpec.describe Integrated::HealthAndInsuranceController do
  describe "#current_step" do
    context "combined application" do
      it "returns 4" do
        current_app = create(:common_application,
                     members: [build(:household_member, requesting_food: "yes", requesting_healthcare: "yes")])

        session[:current_application_id] = current_app.id

        expect(controller.current_step).to eq(4)
      end
    end

    context "food only application" do
      it "returns nil" do
        current_app = create(:common_application,
                             members: [build(:household_member, requesting_food: "yes")])

        session[:current_application_id] = current_app.id

        expect(controller.current_step).to be_nil
      end
    end

    context "healthcare only application" do
      it "returns 3" do
        current_app = create(:common_application,
                             members: [build(:household_member, requesting_healthcare: "yes")])

        session[:current_application_id] = current_app.id

        expect(controller.current_step).to eq(3)
      end
    end
  end
end
