require "rails_helper"

RSpec.describe Integrated::FoodAssistanceController do
  describe "#skip?" do
    context "when housing is stable" do
      context "for single member household" do
        it "returns true" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: [
              build(:household_member),
            ])
          expect(described_class.skip?(application)).to eq(true)
          expect(application.primary_member.requesting_food_yes?).to be_truthy
        end
      end

      context "for multi-member household" do
        it "returns false" do
          application = create(:common_application,
            living_situation: "stable_address",
            members: [
              build(:household_member),
              build(:household_member),
            ])
          expect(described_class.skip?(application)).to eq(false)
        end
      end
    end

    context "when housing is unstable" do
      it "returns true" do
        application = create(:common_application,
          living_situation: "temporary_address",
          members: [
            build(:household_member),
            build(:household_member),
          ])
        expect(described_class.skip?(application)).to eq(true)
        application.reload
        expect(application.members[0].requesting_food_yes?).to be_truthy
        expect(application.members[1].requesting_food_yes?).to be_truthy
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
