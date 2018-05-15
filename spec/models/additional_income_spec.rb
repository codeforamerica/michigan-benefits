require "rails_helper"

RSpec.describe AdditionalIncome do
  describe "validations" do
    context "when income type is a permitted type" do
      it "is valid" do
        income = build(:additional_income, income_type: "unemployment")

        expect(income.valid?).to be_truthy
      end
    end

    context "when income type not in permitted types" do
      it "is invalid" do
        income = build(:additional_income, income_type: "foo")

        expect(income.valid?).to be_falsey
      end
    end

    context "when income type not included" do
      it "is invalid" do
        income = build(:additional_income, income_type: nil)

        expect(income.valid?).to be_falsey
      end
    end
  end
end
