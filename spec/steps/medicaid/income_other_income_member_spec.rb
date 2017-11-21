require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeMember do
  describe "Validations" do
    context "at least one household member has other income" do
      it "is valid" do
        benefit_application = build(:medicaid_application)
        member = build(
          :member,
          other_income: true,
          benefit_application: benefit_application,
        )
        member_not_other_income = build(
          :member,
          other_income: nil,
          benefit_application: benefit_application,
        )

        step = Medicaid::IncomeOtherIncomeMember.new(
          members: [member, member_not_other_income],
        )

        expect(step).to be_valid
      end
    end

    context "no household member has other income" do
      it "is invalid" do
        members = create_list(
          :member,
          2,
          other_income: nil,
          benefit_application: build(:medicaid_application),
        )

        step = Medicaid::IncomeOtherIncomeMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
