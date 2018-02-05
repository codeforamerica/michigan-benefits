require "rails_helper"

RSpec.describe HouseholdRemoveMemberController do
  let(:member_one) { build(:member) }
  let(:member_two) { build(:member) }

  let(:snap_application) do
    create(:snap_application, members: [member_one, member_two])
  end

  before do
    session[:snap_application_id] = snap_application.id
  end

  describe "#update" do
    it "removes member from the application" do
      expect(snap_application.members.count).to eq(2)
      put :update, params: { member_id: member_two.id }

      snap_application.reload
      expect(snap_application.members.count).to eq(1)
    end
  end
end
