require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentMember do
  describe "Validations" do
    context "at least one household member is insured" do
      it "is valid" do
        step = Medicaid::InsuranceCurrentMember.new(
          members: [
            build(:member, insured: true),
            build(:member, insured: false),
          ],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is insured" do
      it "is invalid" do
        step = Medicaid::InsuranceCurrentMember.new(
          members: build_list(:member, 2, insured: false),
        )

        expect(step).not_to be_valid
      end
    end
  end
end
