require "rails_helper"

RSpec.describe Medicaid::TaxFilingWithHouseholdMembersRelationship do
  describe "Validations" do
    context "each member has a specified tax relationship" do
      it "is valid" do
        member_one = build(:member,
          tax_relationship: "Single")
        member_two = build(:member,
          tax_relationship: "Dependent")

        step = described_class.new(
          members: [member_one, member_two],
        )

        expect(step).to be_valid
      end
    end

    context "one member does not specify a tax relationship" do
      it "is invalid" do
        member_one = build(:member,
          tax_relationship: "Single")
        member_two = build(:member,
          tax_relationship: "")

        step = described_class.new(
          members: [member_one, member_two],
        )

        expect(step).not_to be_valid
      end
    end

    context "only one member has 'joint' tax relationship" do
      it "is valid" do
        member_one = build(:member,
          tax_relationship: "Joint")
        member_two = build(:member,
          tax_relationship: "Dependent")

        step = described_class.new(
          members: [member_one, member_two],
        )

        expect(step).to be_valid
      end
    end

    context "more than one member has 'joint' tax relationship" do
      it "is invalid" do
        member_one = build(:member,
          tax_relationship: "Joint")
        member_two = build(:member,
          tax_relationship: "Joint")

        step = described_class.new(
          members: [member_one, member_two],
        )

        expect(step).not_to be_valid
      end
    end
  end
end
