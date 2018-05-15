require "rails_helper"

RSpec.describe IncomeSourcesDetailsForm do
  describe "validations" do
    context "when a member is provided" do
      it "is valid" do
        member = create(:household_member)
        form = IncomeSourcesDetailsForm.new(id: member.id.to_s, additional_incomes: [], valid_members: [member])
        expect(form).to be_valid
      end
    end

    context "when no member id is provided" do
      it "is invalid" do
        member = create(:household_member)
        form = IncomeSourcesDetailsForm.new(id: "", additional_incomes: [], valid_members: [member])
        expect(form).not_to be_valid
      end
    end

    context "when id is not included in member ids" do
      it "is invalid" do
        form = JobDetailsForm.new(id: "foo", employments: [], valid_members: [create(:household_member)])

        expect(form).to_not be_valid
        expect(form.errors[:id]).to be_present
      end
    end

    context "when no amount is provided" do
      it "is valid" do
        member = create(:household_member)
        form = IncomeSourcesDetailsForm.new(
          id: member.id.to_s,
          additional_incomes: [
            AdditionalIncome.new(income_type: "unemployment",
                                 amount: nil),
            AdditionalIncome.new(income_type: "pension",
                                 amount: nil),
          ],
          valid_members: [member],
        )

        expect(form).to be_valid
      end
    end

    context "when amount is a string" do
      it "is valid" do
        member = create(:household_member)
        form = IncomeSourcesDetailsForm.new(
          id: member.id.to_s,
          additional_incomes: [
            AdditionalIncome.new(income_type: "unemployment",
                                 amount: "a gazillion"),
            AdditionalIncome.new(income_type: "pension",
                                 amount: nil),
          ],
          valid_members: [member],
        )

        expect(form).to be_valid
        expect(form.additional_incomes.first.amount).to eq(0)
      end
    end

    context "when all details are present" do
      it "is valid" do
        member = create(:household_member)
        form = IncomeSourcesDetailsForm.new(
          id: member.id.to_s,
          additional_incomes: [
            AdditionalIncome.new(income_type: "unemployment",
                                 amount: 100),
            AdditionalIncome.new(income_type: "pension",
                                 amount: 200),
          ],
          valid_members: [member],
        )

        expect(form).to be_valid
      end
    end
  end
end
