require "rails_helper"

RSpec.describe AddAccountForm do
  describe "validations" do
    let(:member) do
      create(:household_member)
    end

    context "valid" do
      it "is valid with all required inputs" do
        form = AddAccountForm.new(
          account_type: "checking",
          member_ids: [member.id.to_s],
          valid_members: [member],
          institution: "Credible Credit Union",
        )

        expect(form).to be_valid
      end
    end

    context "invalid" do
      it "requires account_type" do
        form = AddAccountForm.new(
          member_ids: [member.id.to_s],
          valid_members: [member],
          institution: "Credible Credit Union",
        )

        expect(form).not_to be_valid
        expect(form.errors[:account_type]).to be_present
      end

      it "requires institution" do
        form = AddAccountForm.new(
          account_type: "checking",
          member_ids: [member.id.to_s],
          valid_members: [member],
          institution: " ",
        )

        expect(form).not_to be_valid
        expect(form.errors[:institution]).to be_present
      end

      it "requires member_ids" do
        form = AddAccountForm.new(
          account_type: "checking",
          valid_members: [member],
          institution: "Credible Credit Union",
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end

      it "requires all member_ids to belong to valid_members" do
        invalid_member = create(:household_member)

        form = AddAccountForm.new(
          account_type: "checking",
          member_ids: [member.id.to_s, invalid_member.id.to_s],
          valid_members: [member],
          institution: "Credible Credit Union",
        )

        expect(form).not_to be_valid
        expect(form.errors[:member_ids]).to be_present
      end
    end
  end
end
