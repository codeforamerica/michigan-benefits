require "rails_helper"

RSpec.describe Integrated::RemoveHouseholdMemberController do
  describe "#update" do
    it "removes member from the application" do
      member_one = build(:household_member)
      member_two = build(:household_member)
      current_app = create(:common_application,
                           members: [member_one, member_two])

      session[:current_application_id] = current_app.id
      expect(current_app.members.count).to eq(2)

      put :update, params: { form: { member_id: member_two.id } }
      current_app.reload
      expect(current_app.members.count).to eq(1)
    end
  end
end
