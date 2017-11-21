require "rails_helper"

RSpec.describe Medicaid::IncomeSelfEmploymentMember do
  describe "Validations" do
    context "at least one household member is self employed" do
      it "is valid" do
        benefit_application = build(:medicaid_application)
        member = create(
          :member,
          self_employed: true,
          benefit_application: benefit_application,
        )
        member_not_self_employed = create(
          :member,
          self_employed: nil,
          benefit_application: benefit_application,
        )

        step = Medicaid::IncomeSelfEmploymentMember.new(
          members: [member, member_not_self_employed],
        )

        expect(step).to be_valid
      end
    end

    context "no household member is self employed" do
      it "is invalid" do
        members = create_list(
          :member,
          2,
          self_employed: nil,
          benefit_application: build(:medicaid_application),
        )

        step = Medicaid::IncomeSelfEmploymentMember.new(members: members)

        expect(step).not_to be_valid
      end
    end
  end
end
