require "rails_helper"

RSpec.describe Expense do
  describe "validations" do
    context "when expense type is a permitted type" do
      it "is valid" do
        expense = build(:expense, expense_type: "phone")

        expect(expense.valid?).to be_truthy
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
        non_utility = build(:expense, expense_type: "foo")
        non_utility.save(:validate => false)

        utility = create(:expense, expense_type: "phone")

        expect(Expense.utilities.count).to eq(1)
        expect(Expense.utilities).to match_array([utility])
      end
    end
  end
end
