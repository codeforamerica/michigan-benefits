require "rails_helper"

RSpec.describe SingleExpenseDetailsForm do
  describe "validations" do
    context "valid" do
      it "is valid with all required inputs" do
        member = create(:household_member)

        form = SingleExpenseDetailsForm.new(
          member_ids: [member.id.to_s],
          valid_members: [member],
        )

        expect(form).to be_valid
      end
    end

    context "invalid" do
      it "requires amount to be a number" do
        member = create(:household_member)

        form = SingleExpenseDetailsForm.new(
          amount: "gobbledygook",
          member_ids: [member.id.to_s],
          valid_members: [member],
        )

        expect(form).not_to be_valid
        expect(form.errors[:amount]).to be_present
      end

      it "requires all members to pertain to current application" do
        valid_member = create(:household_member)
        invalid_member = create(:household_member)

        form = SingleExpenseDetailsForm.new(
          member_ids: [valid_member.id.to_s, invalid_member.id.to_s],
          valid_members: [valid_member],
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end

      it "requires member_ids" do
        form = SingleExpenseDetailsForm.new(
          valid_members: [create(:household_member)],
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end
    end
  end
end
