require "rails_helper"

RSpec.describe Integrated::FoodAssistanceController do
  describe "#skip?" do
    context "when housing is stable" do
      context "for single member household" do
        it "returns true and includes member in snap household" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: build_list(:household_member, 1))

          expect(described_class.skip?(application)).to eq(true)

          application.primary_member.reload

          expect(application.primary_member.requesting_food).to eq("yes")
          expect(application.primary_member.buy_and_prepare_food_together).to eq("yes")
        end
      end

      context "for household with more than one member" do
        it "returns false and does not update members" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: build_list(:household_member, 3))

          to_skip = nil
          expect do
            to_skip = described_class.skip?(application)
          end.to_not(change { application.primary_member.requesting_food })
          expect(to_skip).to eq(false)
        end
      end
    end

    context "when housing is unstable" do
      it "returns true and includes member in snap household" do
        application = create(:common_application,
          living_situation: "temporary_address",
          members: build_list(:household_member, 1))

        expect(described_class.skip?(application)).to eq(true)

        application.members.map(&:reload)

        expect(application.members[0].requesting_food).to eq("yes")
        expect(application.members[0].buy_and_prepare_food_together).to eq("yes")
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      it "marks members as requesting food" do
        current_app = create(:common_application,
                             members: [create(:household_member), create(:household_member)])
        session[:current_application_id] = current_app.id

        member1 = current_app.members[0]
        member2 = current_app.members[1]

        valid_params = {
          form: {
            members: {
              member1.id => { "requesting_food" => "yes" },
              member2.id => { "requesting_food" => "no" },
            },
          },
        }

        put :update, params: valid_params

        current_app.reload

        expect(current_app.primary_member.requesting_food_yes?).to be_truthy
        expect(current_app.members[1].requesting_food_no?).to be_truthy
      end
    end
  end
end
