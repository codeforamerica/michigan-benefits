require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentType do
  describe "Validations" do
    context "at least one household member has an insurance type" do
      it "is valid" do
        member = create(:member, insurance_type: "Medicaid")
        member_without_insurance =
          create(:member, insurance_type: nil)

        step = Medicaid::InsuranceCurrentType.new(
          members: [member, member_without_insurance],
        )

        expect(step).to be_valid
      end
    end

    context "no household member has an insurance type" do
      it "is invalid" do
        members = create_list(:member, 2, insurance_type: nil)

        step = Medicaid::InsuranceCurrentType.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
