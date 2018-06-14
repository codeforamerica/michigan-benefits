require "rails_helper"

RSpec.describe Integrated::RemoveHealthcareMemberController do
  describe "#update" do
    context "filing for taxes" do
      it "removes member from the healthcare household" do
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
        expect(flash[:notice]).to eq "Removed the member from your household."
      end
    end

    context "not filing for taxes and applying for healthcare only" do
      it "removes member from the household altogether" do
        member_one = build(:household_member, filing_taxes_next_year: "no")
        member_two = build(:household_member)
        current_app = create(:common_application,
                             members: [member_one, member_two],
                             navigator: build(:application_navigator, applying_for_healthcare: true))

        session[:current_application_id] = current_app.id
        expect(current_app.members.count).to eq(2)

        put :update, params: { form: { member_id: member_two.id } }
        current_app.reload
        expect(current_app.members.count).to eq(1)
        expect(flash[:notice]).to eq "Removed the member from your household."
      end
    end
  end
end
