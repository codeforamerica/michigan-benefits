require "rails_helper"

RSpec.describe Medicaid::IntroHouseholdRemoveMemberController do
  let(:member_one) { build(:member) }
  let(:member_two) { build(:member) }

  let(:medicaid_application) do
    create(:medicaid_application, members: [member_one, member_two])
  end

  before do
    session[:medicaid_application_id] = medicaid_application.id
  end

  describe "#update" do
    it "removes member from the application" do
      expect(medicaid_application.members.count).to eq(2)
      put :update, params: { member_id: member_two.id }

      medicaid_application.reload
      expect(medicaid_application.members.count).to eq(1)
    end
  end
end
