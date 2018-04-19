require "rails_helper"

RSpec.describe Expense do
  describe "validations" do
    context "when expense type is a permitted type" do
      it "is valid" do
        utility_expense = build(:expense, expense_type: "phone")
        housing_expense = build(:expense, expense_type: "rent")

        expect(utility_expense.valid?).to be_truthy
        expect(housing_expense.valid?).to be_truthy
      end
    end

    context "when expense type not in permitted types" do
      it "is invalid" do
        expense = build(:expense, expense_type: "foo")

        expect(expense.valid?).to be_falsey
      end
    end

    context "when expense type not included" do
      it "is invalid" do
        expense = build(:expense, expense_type: nil)

        expect(expense.valid?).to be_falsey
      end
    end
  end

  describe "scopes" do
    describe ".utilities" do
      it "returns utility expenses" do
        build(:expense, expense_type: "rent")
        utility = create(:expense, expense_type: "phone")

        expect(Expense.utilities.count).to eq(1)
        expect(Expense.utilities).to match_array([utility])
      end
    end

    describe ".housing" do
      it "returns housing expenses" do
        build(:expense, expense_type: "mortgage")
        housing = create(:expense, expense_type: "rent")

        expect(Expense.housing.count).to eq(1)
        expect(Expense.housing).to match_array([housing])
      end
    end
  end
end
