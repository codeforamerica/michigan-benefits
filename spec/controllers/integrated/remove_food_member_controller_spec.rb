require "rails_helper"

RSpec::Matchers.define_negated_matcher :not_change, :change

RSpec.describe Integrated::RemoveFoodMemberController do
  describe "#update" do
    it "removes member from SNAP applying members" do
      member_one = build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "yes")
      member_two = build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "yes")
      current_app = create(:common_application,
                           members: [member_one, member_two])

      session[:current_application_id] = current_app.id
      expect(current_app.food_applying_members.count).to eq(2)
      expect(current_app.food_household_members.count).to eq(2)

      expect do
        put :update, params: { form: { member_id: member_two.id } }
      end.to not_change {
        current_app.food_applying_members.count
      }.and change {
        current_app.food_household_members.count
      }.by(-1)
    end
  end
end
