require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurity do
  describe "Validations" do
    context "each household member has a valid last 4 SSN" do
      it "is valid" do
        member = build(:member, last_four_ssn: "1234")
        member_without_ssn = build(:member, last_four_ssn: nil)

        step = Medicaid::ContactSocialSecurity.new(
          members: [member, member_without_ssn],
        )

        expect(step).to be_valid
      end
    end

    context "a household member has an invalid last 4 SSN" do
      it "is invalid" do
        member = build(:member, last_four_ssn: "1234")
        invalid_member = build(:member, last_four_ssn: "1234567")

        step = Medicaid::ContactSocialSecurity.new(
          members: [member, invalid_member],
        )

        expect(step).not_to be_valid
      end
    end
  end
end
