require "rails_helper"

RSpec.describe Medicaid::IncomeOtherIncomeType do
  describe "Validations" do
    context "the household member has other income" do
      it "is valid" do
        benefit_application = build(:medicaid_application)
        member = create(
          :member,
          other_income: true,
          benefit_application: benefit_application,
        )

        step = Medicaid::IncomeOtherIncomeType.new(
          id: member.id,
          other_income_types: ["Unemployment"],
        )

        expect(step).to be_valid
      end
    end

    context "a member with other income is missing an other income type" do
      it "is invalid" do
        benefit_application = build(:medicaid_application)
        member = create(
          :member,
          other_income: true,
          other_income_types: [],
          benefit_application: benefit_application,
        )

        step = Medicaid::IncomeOtherIncomeType.new(
          id: member.id,
          other_income_types: member.other_income_types,
        )

        expect(step).not_to be_valid
      end
    end
  end
end
