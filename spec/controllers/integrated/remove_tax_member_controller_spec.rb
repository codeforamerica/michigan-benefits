require "rails_helper"

RSpec.describe Integrated::RemoveTaxMemberController do
  describe "#update" do
    it "removes member from the tax household" do
      member_one = build(:household_member, tax_relationship: "primary")
      member_two = build(:household_member, tax_relationship: "dependent")
      current_app = create(:common_application,
                           members: [member_one, member_two])

      session[:current_application_id] = current_app.id
      expect(current_app.tax_household_members.count).to eq(2)

      put :update, params: { form: { member_id: member_two.id } }
      current_app.reload
      expect(current_app.tax_household_members.count).to eq(1)
      expect(current_app.members[1].tax_relationship_not_included?).to be_truthy
    end
  end
end
