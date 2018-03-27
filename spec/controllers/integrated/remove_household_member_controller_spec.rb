require "rails_helper"

RSpec.describe Integrated::RemoveHouseholdMemberController do
  describe "#update" do
    it "removes member from the application" do
      member_one = build(:household_member)
      member_two = build(:household_member)
      current_app = create(:common_application,
        members: [member_one, member_two])

      session[:current_application_id] = current_app.id

      expect do
        put :update, params: { form: { member_id: member_two.id } }
      end.to change { current_app.members.count }.by(-1)
    end

    context "when removed member is spouse" do
      it "updates primary member to unmarried" do
        member_one = build(:household_member, married: "yes")
        member_two = build(:household_member, married: "yes", relationship: "spouse")
        current_app = create(:common_application, members: [
                               member_one, member_two
                             ])

        session[:current_application_id] = current_app.id

        expect do
          put :update, params: { form: { member_id: member_two.id } }
        end.to change { current_app.primary_member.married_no? }.from(false).to(true)
      end
    end
  end
end
