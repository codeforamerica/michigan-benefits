require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeMember do
  describe "Validations" do
    context "at least one household member has other income" do
      it "is valid" do
        member = create(:member, other_income: true)
        member_not_other_income = create(:member, other_income: nil)

        step = Medicaid::IncomeOtherIncomeMember.new(
          members: [member, member_not_other_income],
        )

        expect(step).to be_valid
      end
    end

    context "no household member has other income" do
      it "is invalid" do
        members = create_list(:member, 2, other_income: nil)

        step = Medicaid::IncomeOtherIncomeMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
