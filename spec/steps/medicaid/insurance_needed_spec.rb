require "rails_helper"

RSpec.describe Medicaid::InsuranceNeeded do
  describe "Validations" do
    context "at least one household member needs insurance" do
      it "is valid" do
        member = build(:member, requesting_health_insurance: true)
        member_not_requesting =
          build(:member, requesting_health_insurance: false)

        step = Medicaid::InsuranceNeeded.new(
          members: [member, member_not_requesting],
        )

        expect(step).to be_valid
      end
    end

    context "no household members need insurance" do
      it "is invalid" do
        members = build_list(:member, 2, requesting_health_insurance: false)

        step = Medicaid::InsuranceNeeded.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
