require "rails_helper"

RSpec.describe Medicaid::AmountsIncome do
  context "has 2 jobs" do
    it "validates that there is income for 2 jobs" do
      member = create(
        :member,
        employed_number_of_jobs: 2,
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        employed_pay_quantities: [1, 2],
        employed_employer_names: ["Acme", "Co"],
        employed_payment_frequency: ["Weekly", "Weekly"],
      )

      expect(step).to be_valid
    end
  end

  context "fills out only one job's info" do
    it "invalidates the object because 1 income amount is missing" do
      member = create(
        :member,
        employed_number_of_jobs: 2,
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        employed_pay_quantities: [1],
        employed_employer_names: ["Acme"],
        employed_payment_frequency: ["Weekly"],
      )

      expect(step).not_to be_valid
      expect(step.errors.messages[:incomes_missing].size).to eq 3
    end
  end

  context "empty strings" do
    it "is invalid" do
      member = create(
        :member,
        employed_number_of_jobs: 2,
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        employed_pay_quantities: ["1", ""],
        employed_employer_names: ["", ""],
        employed_payment_frequency: ["", "Weekly"],
      )

      expect(step).not_to be_valid
      expect(step.errors.messages[:incomes_missing].size).to eq 3
    end
  end

  context "member receives unemployment" do
    it "is valid if the amount is provided" do
      member = create(
        :member,
        other_income_types: %w(unemployment),
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        unemployment_income: 100,
      )

      expect(step).to be_valid
    end

    it "is invalid if the amount is not provided" do
      member = create(
        :member,
        other_income_types: %w(unemployment),
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        unemployment_income: "",
      )

      expect(step).not_to be_valid
    end
  end

  context "member is self-employed" do
    it "is valid if the amount is provided" do
      member = create(
        :member,
        self_employed: true,
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        self_employed_monthly_income: 100,
      )

      expect(step).to be_valid
    end

    it "is invalid if self-employment income is not provided" do
      member = create(
        :member,
        self_employed: true,
        benefit_application: build(:medicaid_application),
      )

      step = Medicaid::AmountsIncome.new(
        member_id: member.id,
        self_employed_monthly_income: "",
      )

      expect(step).not_to be_valid
    end
  end
end
