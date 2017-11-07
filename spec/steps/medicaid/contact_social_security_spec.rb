require "rails_helper"

RSpec.describe Medicaid::ContactSocialSecurity do
  describe "Validations" do
    context "each household member has a valid SSN" do
      it "is valid" do
        member = build(:member, ssn: "123456789")
        member_without_ssn = build(:member, ssn: nil)

        step = Medicaid::ContactSocialSecurity.new(
          members: [member, member_without_ssn],
        )

        expect(step).to be_valid
      end
    end

    context "a household member has an invalid SSN" do
      it "is invalid" do
        member = build(:member, ssn: "123456789")
        invalid_member = build(:member, ssn: "1234")

        step = Medicaid::ContactSocialSecurity.new(
          members: [member, invalid_member],
        )

        expect(step).not_to be_valid
      end
    end
  end
end
