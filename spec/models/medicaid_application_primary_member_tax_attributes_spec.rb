require "rails_helper"

RSpec.describe MedicaidApplicationPrimaryMemberTaxAttributes do
  describe "#to_h" do
    context "joint filing tax relationship" do
      it "returns key indicating that the member is filing jointly" do
        medicaid_application = create(:medicaid_application)
        member = build(
          :member,
          benefit_application: medicaid_application,
          tax_relationship: "Joint",
        )

        result = MedicaidApplicationPrimaryMemberTaxAttributes.new(
          member: member,
        ).to_h

        expect(result[:primary_member_tax_relationship_joint_yes]).to eq "Yes"
      end

      it "returns the other joint filing member first name" do
        medicaid_application = create(:medicaid_application)
        spouse = create(
          :member,
          first_name: "Spousey",
          last_name: "Spouserson",
          benefit_application: medicaid_application,
          tax_relationship: "Joint",
        )
        member = create(
          :member,
          spouse: spouse,
          benefit_application: medicaid_application,
          tax_relationship: "Joint",
        )

        result = MedicaidApplicationPrimaryMemberTaxAttributes.new(
          member: member,
        ).to_h

        expect(result[:primary_member_joint_filing_member_name]).to eq(
          "Spousey Spouserson",
        )
      end

      it "is claimed as dependent" do
        medicaid_application = create(:medicaid_application)
        member = create(
          :member,
          benefit_application: medicaid_application,
          claimed_as_dependent: true,
        )

        result = MedicaidApplicationPrimaryMemberTaxAttributes.new(
          member: member,
        ).to_h

        expect(result[:primary_member_claimed_as_dependent_yes]).to eq("Yes")
      end
    end
  end
end
