require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentType do
  describe "Validations" do
    context "each insured household member has an insurance type" do
      it "is valid" do
        member = create(:member,
                        is_insured: true,
                        insurance_type: "Medicaid")

        member_without_insurance = create(:member,
                                          is_insured: false,
                                          insurance_type: nil)

        step = Medicaid::InsuranceCurrentType.new(
          members: [member, member_without_insurance],
        )

        expect(step).to be_valid
      end
    end

    context "an insured household member is missing an insurance type" do
      it "is invalid" do
        member = create(:member,
                        is_insured: true,
                        insurance_type: "Medicaid")

        insured_member_without_type = create(:member,
                                             is_insured: true,
                                             insurance_type: nil)

        step = Medicaid::InsuranceCurrentType.new(
          members: [member, insured_member_without_type],
        )

        expect(step).not_to be_valid
      end
    end
  end

  describe "#insured_members" do
    context "with insured members" do
      it "returns all insured" do
        insured_member = create(:member, is_insured: true)
        uninsured_member = create(:member, is_insured: false)

        step = Medicaid::InsuranceCurrentType.new(
          members: [insured_member, uninsured_member],
        )

        expect(step.insured_members).to eq([insured_member])
      end
    end

    context "without insured members" do
      it "returns an empty array" do
        step = Medicaid::InsuranceCurrentType.new(
          members: create_list(:member, 2, is_insured: false),
        )

        expect(step.insured_members).to eq([])
      end
    end
  end
end
