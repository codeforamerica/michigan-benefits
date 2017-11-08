require "rails_helper"

RSpec.describe Medicaid::AmountsIncome do
  context "has 2 jobs, 2 salaries" do
    it "validates that there is income for 2 jobs" do
      member = create(:member, employed_number_of_jobs: 2)

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        employed_monthly_income: [1, 2],
      )

      expect(step).to be_valid
    end
  end

  context "has 2 jobs, 1 income" do
    it "invalidates the object because 1 income amount is missing" do
      member = create(:member, employed_number_of_jobs: 2)

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        employed_monthly_income: [1],
      )

      expect(step).not_to be_valid
    end
  end

  context "member receives unemployment" do
    it "is valid if the amount is provided" do
      member = create(:member, other_income_types: %w(unemployment))

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        unemployment_income: 100,
      )

      expect(step).to be_valid
    end

    it "is invalid if the amount is not provided" do
      member = create(:member, other_income_types: %w(unemployment))

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        unemployment_income: "",
      )

      expect(step).not_to be_valid
    end
  end

  context "member is self-employed" do
    it "is valid if the amount is provided" do
      member = create(:member, self_employed: true)

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        self_employed_monthly_income: 100,
      )

      expect(step).to be_valid
    end

    it "is invalid if self-employment income is not provided" do
      member = create(:member, self_employed: true)

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        self_employed_monthly_income: "",
      )

      expect(step).not_to be_valid
    end
  end
end
