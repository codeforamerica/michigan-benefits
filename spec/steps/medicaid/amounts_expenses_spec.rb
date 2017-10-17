require "rails_helper"

RSpec.describe Medicaid::AmountsExpenses do
  context "self employed" do
    it "validates presence of self employment expenses" do
      step = Medicaid::AmountsExpenses.new(
        self_employed: "true",
        self_employment_expenses: nil,
      )

      expect(step).to be_invalid
    end
  end

  context "not self employed" do
    it "does not validate presence of self employment expenses" do
      step = Medicaid::AmountsExpenses.new(
        self_employed: false,
        self_employment_expenses: nil,
      )

      expect(step).to be_valid
    end
  end
end
