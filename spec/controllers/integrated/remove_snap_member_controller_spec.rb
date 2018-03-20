require "rails_helper"

RSpec.describe Integrated::RemoveSnapMemberController do
  describe "#update" do
    it "removes member from SNAP applying members" do
      member_one = build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "yes")
      member_two = build(:household_member, requesting_food: "yes", buy_and_prepare_food_together: "yes")
      current_app = create(:common_application,
                           members: [member_one, member_two])

      session[:current_application_id] = current_app.id
      expect(current_app.snap_applying_members.count).to eq(2)
      expect(current_app.snap_household_members.count).to eq(2)

      put :update, params: { form: { member_id: member_two.id } }
      current_app.reload
      expect(current_app.snap_applying_members.count).to eq(2)
      expect(current_app.snap_household_members.count).to eq(1)
    end
  end
end
