require "rails_helper"

RSpec.describe MedicaidApplicationAttributes do
  describe "#to_h" do
    context "unstable housing" do
      it "returns residential address as Homeless" do
        medicaid_application = create(
          :medicaid_application,
          stable_housing: false,
        )

        data = MedicaidApplicationAttributes.new(
          medicaid_application: medicaid_application,
        ).to_h

        expect(data).to include(
          residential_address_street_address: "Homeless",
        )
      end
    end

    describe "insurance types" do
      it_should_behave_like "insurance type", "medicaid", "Medicaid"

      context "applicant is on medicare" do
        it_should_behave_like "insurance type", "medicare", "Medicare"
        it "should fill out yes for do you need help" do
          member_with_medicare = build(
            :member,
            insurance_type: "Medicare",
          )
          medicaid_application = create(
            :medicaid_application,
            members: [member_with_medicare],
          )

          data = MedicaidApplicationAttributes.new(
            medicaid_application: medicaid_application,
          ).to_h

          expect(data).to include(
            help_paying_medicare_premiums_yes: "Yes",
          )
        end
      end

      it_should_behave_like "insurance type", "chip", "CHIP/MIChild"
      it_should_behave_like "insurance type", "va", "VA health care programs"
      it_should_behave_like "insurance type",
        "employer", "Employer or individual plan"
      it_should_behave_like "insurance type", "other", "Other"
    end

    context "dependents present" do
      it "returns first names of members with 'Dependent' tax relationship" do
        dependent_member = build(
          :member,
          first_name: "Deepa",
          tax_relationship: "Dependent",
        )
        joint_member = build(
          :member,
          first_name: "Johnt",
          tax_relationship: "Joint",
        )
        second_dependent_member = build(
          :member,
          first_name: "Secci",
          tax_relationship: "Dependent",
        )
        medicaid_application = create(
          :medicaid_application,
          members: [dependent_member, joint_member, second_dependent_member],
        )

        data = MedicaidApplicationAttributes.new(
          medicaid_application: medicaid_application,
        ).to_h

        expect(data).to include(
          dependent_member_names: "Deepa, Secci",
          any_member_tax_relationship_dependent_yes: "Yes",
        )
      end
    end
  end
end
