require "rails_helper"

RSpec.describe SelfEmploymentDetailsForm do
  describe "validations" do
    context "when no info provided" do
      it "is valid" do
        form = SelfEmploymentDetailsForm.new(
          self_employment_description: nil,
          self_employment_income: nil,
          self_employment_expense: nil,
        )

        expect(form).to be_valid
      end
    end

    context "when valid info provided" do
      it "is valid" do
        form = SelfEmploymentDetailsForm.new(
          self_employment_description: "dog petter",
          self_employment_income: "100",
          self_employment_expense: "100",
        )

        expect(form).to be_valid
      end
    end

    context "when income is not an integer" do
      it "is invalid" do
        form = SelfEmploymentDetailsForm.new(
          self_employment_income: "foo",
        )

        expect(form).not_to be_valid
        expect(form.errors[:self_employment_income]).to be_present
      end
    end

    context "when expense is not an integer" do
      it "is invalid" do
        form = SelfEmploymentDetailsForm.new(
          self_employment_expense: "foo",
        )

        expect(form).not_to be_valid
        expect(form.errors[:self_employment_expense]).to be_present
      end
    end
  end
end
