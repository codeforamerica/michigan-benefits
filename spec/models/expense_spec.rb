require "rails_helper"

RSpec.describe Expense do
  describe "validations" do
    context "when expense type is a permitted type" do
      it "is valid" do
        housing_expense = build(:expense, expense_type: "rent")
        medical_expense = build(:expense, expense_type: "dental")
        utility_expense = build(:expense, expense_type: "phone")

        expect(housing_expense.valid?).to be_truthy
        expect(medical_expense.valid?).to be_truthy
        expect(utility_expense.valid?).to be_truthy
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
    describe ".housing" do
      it "returns housing expenses" do
        build(:expense, expense_type: "mortgage")
        housing = create(:expense, expense_type: "rent")

        expect(Expense.housing.count).to eq(1)
        expect(Expense.housing).to match_array([housing])
      end
    end
    describe ".medical" do
      it "returns medical expenses" do
        build(:expense, expense_type: "mortgage")
        medical = create(:expense, expense_type: "dental")

        expect(Expense.medical.count).to eq(1)
        expect(Expense.medical).to match_array([medical])
      end
    end

    describe ".utilities" do
      it "returns utility expenses" do
        build(:expense, expense_type: "rent")
        utility = create(:expense, expense_type: "phone")

        expect(Expense.utilities.count).to eq(1)
        expect(Expense.utilities).to match_array([utility])
      end
    end

    describe ".dependent_care" do
      it "returns dependent care expenses" do
        build(:expense, expense_type: "rent")
        dependent_care = create(:expense, expense_type: "childcare")

        expect(Expense.dependent_care.count).to eq(1)
        expect(Expense.dependent_care).to match_array([dependent_care])
      end
    end

    describe ".court_ordered" do
      it "returns court ordered expenses" do
        build(:expense, expense_type: "rent")
        court_ordered = create(:expense, expense_type: "child_support")

        expect(Expense.court_ordered.count).to eq(1)
        expect(Expense.court_ordered).to match_array([court_ordered])
      end
    end

    describe ".student_loan_interest" do
      it "returns court ordered expenses" do
        build(:expense, expense_type: "rent")
        student_loan_interest = create(:expense, expense_type: "student_loan_interest")

        expect(Expense.student_loan_interest.count).to eq(1)
        expect(Expense.student_loan_interest).to match_array([student_loan_interest])
      end
    end
  end
end
