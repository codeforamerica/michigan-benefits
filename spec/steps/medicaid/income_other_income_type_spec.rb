require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeType do
  describe "Validations" do
    context "the household member has other income" do
      it "is valid" do
        member = create(:member, other_income: true)

        step = Medicaid::IncomeOtherIncomeType.new(
          member_id: member.id,
          other_income_types: ["Unemployment"],
        )

        expect(step).to be_valid
      end
    end

    context "a member with other income is missing an other income type" do
      it "is invalid" do
        member = create(
          :member,
          other_income: true,
          other_income_types: [],
        )

        step = Medicaid::IncomeOtherIncomeType.new(
          member_id: member.id,
          other_income_types: member.other_income_types,
        )

        expect(step).not_to be_valid
      end
    end
  end
end
