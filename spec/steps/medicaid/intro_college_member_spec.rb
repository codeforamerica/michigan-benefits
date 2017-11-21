require "rails_helper"

RSpec.describe Medicaid::IntroCollegeMember do
  describe "Validations" do
    context "at least one household member is a student" do
      it "is valid" do
        member = build(:member, in_college: true)
        member_not_in_college =
          build(:member, in_college: false)

        step = Medicaid::IntroCollegeMember.new(
          members: [member, member_not_in_college],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is a student" do
      it "is invalid" do
        members = build_list(:member, 2, in_college: false)

        step = Medicaid::IntroCollegeMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
