require "rails_helper"

RSpec.describe Integrated::BuyAndPrepareFoodWithOtherPersonController do
  describe "#skip?" do
    context "when applicant has stable housing" do
      context "when household has two members applying for food" do
        it "returns false" do
          members = build_list(:household_member, 2, requesting_food: "yes") + [build(:household_member)]
          application = create(:common_application,
            living_situation: "stable_address",
            members: members)

          skip_step = Integrated::BuyAndPrepareFoodWithOtherPersonController.skip?(application)
          expect(skip_step).to eq(false)
        end
      end

      context "when household has one or more than two members applying for food" do
        it "returns true" do
          single_member_application = create(:common_application,
            living_situation: "stable_address",
            members: [
              build(:household_member, requesting_food: "yes"),
              build(:household_member),
            ])

          three_member_application = create(:common_application,
            living_situation: "stable_address",
            members: build_list(:household_member, 3))

          single_member_skip_step =
            Integrated::BuyAndPrepareFoodWithOtherPersonController.skip?(single_member_application)
          expect(single_member_skip_step).to eq(true)

          three_member_skip_step =
            Integrated::BuyAndPrepareFoodWithOtherPersonController.skip?(three_member_application)
          expect(three_member_skip_step).to eq(true)
        end
      end
    end

    context "when applicant has unstable housing" do
      it "returns true" do
        application = create(:common_application, living_situation: "temporary_address")

        skip_step = Integrated::BuyAndPrepareFoodWithOtherPersonController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "when two members are applying for food" do
      context "when client indicates they buy and prepare food with person" do
        it "updates trait on member to 'yes'" do
          members = build_list(:household_member, 2, requesting_food: "yes")
          current_app = create(:common_application, members: members)

          session[:current_application_id] = current_app.id

          expect do
            put :update, params: { form: { buy_and_prepare_food_together: "yes" } }
          end.to_not change { current_app.primary_member.buy_and_prepare_food_together }

          members.map(&:reload)

          expect(members.second.buy_and_prepare_food_together).to eq("yes")
        end
      end

      context "when client indicates they do not buy and prepare food with person" do
        it "updates trait on second member to 'no'" do
          members = build_list(:household_member, 2, requesting_food: "yes")
          current_app = create(:common_application, members: members)

          session[:current_application_id] = current_app.id

          expect do
            put :update, params: { form: { buy_and_prepare_food_together: "no" } }
          end.to_not change { current_app.primary_member.buy_and_prepare_food_together }

          members.map(&:reload)

          expect(members.second.buy_and_prepare_food_together).to eq("no")
        end
      end
    end
  end
end
