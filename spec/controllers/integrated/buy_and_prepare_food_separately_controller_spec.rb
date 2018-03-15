require "rails_helper"

RSpec.describe Integrated::BuyAndPrepareFoodSeparatelyController do
  describe "#skip?" do
    context "when all household members share food costs" do
      it "returns true" do
        application = create(:common_application,
                             navigator: create(:application_navigator, all_share_food_costs: true))

        skip_step = Integrated::BuyAndPrepareFoodSeparatelyController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      it "updates the members preparing food separately" do
        current_app = create(:common_application,
                             members: [create(:household_member, requesting_food: "yes"),
                                       create(:household_member, requesting_food: "yes"),
                                       create(:household_member, requesting_food: "yes")])
        session[:current_application_id] = current_app.id

        member2 = current_app.members[1]
        member3 = current_app.members[2]

        valid_params = {
          form: {
            members: {
              member2.id => { buy_and_prepare_food_together: "yes" },
              member3.id => { buy_and_prepare_food_together: "no" },
            },
          },
        }

        put :update, params: valid_params

        current_app.reload

        expect(current_app.members[1].buy_and_prepare_food_together_yes?).to be_truthy
        expect(current_app.members[2].buy_and_prepare_food_together_no?).to be_truthy
      end
    end
  end
end
