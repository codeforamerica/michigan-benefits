require "rails_helper"

RSpec.describe Medicaid::InsuranceCurrentMember do
  describe "Validations" do
    context "at least one household member is insured" do
      it "is valid" do
        member = create(:member, is_insured: true)
        member_not_insured =
          create(:member, is_insured: false)

        step = Medicaid::InsuranceCurrentMember.new(
          members: [member, member_not_insured],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is insured" do
      it "is invalid" do
        members = create_list(:member, 2, is_insured: false)

        step = Medicaid::InsuranceCurrentMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
