require "rails_helper"

RSpec.describe YourExpensesDetailsForm do
  describe "validations" do
    context "when amount is a string" do
      it "is not valid" do
        form = YourExpensesDetailsForm.new(
          expenses: [
            build(:expense, amount: "a gazillion"),
            build(:expense, amount: 100),
          ],
        )

        expect(form).to_not be_valid
        expect(form.errors[:expenses]).to be_present
        expect(form.expenses.first.errors[:amount]).to be_present
      end
    end

    context "when no amount is provided" do
      it "is valid" do
        form = YourExpensesDetailsForm.new(
          expenses: [
            build(:expense, amount: nil),
            build(:expense, amount: nil),
          ],
        )

        expect(form).to be_valid
      end
    end

    context "when all details are present" do
      it "is valid" do
        form = YourExpensesDetailsForm.new(
          expenses: [
            build(:expense, amount: 100),
            build(:expense, amount: 100),
          ],
        )

        expect(form).to be_valid
      end
    end
  end
end
