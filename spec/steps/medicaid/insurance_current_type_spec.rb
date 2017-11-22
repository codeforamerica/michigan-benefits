require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentType do
  describe "Validations" do
    context "the household member has an insurance type" do
      it "is valid" do
        benefit_application = build(:medicaid_application)
        member = create(
          :member,
          insured: true,
          requesting_health_insurance: true,
          benefit_application: benefit_application,
        )

        step = Medicaid::InsuranceCurrentType.new(
          member_id: member.id,
          insurance_type: "Medicaid",
        )

        expect(step).to be_valid
      end
    end

    context "an insured household member is missing an insurance type" do
      it "is invalid" do
        benefit_application = build(:medicaid_application)
        insured_member_without_type = create(
          :member,
          insured: true,
          requesting_health_insurance: true,
          benefit_application: benefit_application,
        )

        step = Medicaid::InsuranceCurrentType.new(
          member_id: insured_member_without_type.id,
          insurance_type: nil,
        )

        expect(step).not_to be_valid
      end
    end
  end
end
