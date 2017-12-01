require "rails_helper"

RSpec.describe MedicaidApplicationAdditionalMemberTaxAttributes do
  describe "#to_h" do
    context "primary member is filing taxes" do
      context "member is filing jointly with primary member" do
        it "checks 'is filing' and lists primary member name" do
          second_member = build(:member, tax_relationship: "Joint")
          create(
            :medicaid_application,
            filing_federal_taxes_next_year: true,
            filing_taxes_with_household_members: true,
            members: [
              build(
                :member,
                first_name: "Primo",
                last_name: "Member",
                tax_relationship: "Joint",
              ),
              second_member,
            ],
          )

          results = MedicaidApplicationAdditionalMemberTaxAttributes.new(
            member: second_member,
          ).to_h

          expect(results).to eq(
            second_member_filing_federal_taxes_next_year_yes: "Yes",
            second_member_tax_relationship_joint_yes: "Yes",
            second_member_joint_filing_member_name: "Primo Member",
            second_member_claiming_dependent_yes: nil,
            second_member_dependent_member_names: "",
            second_member_claimed_as_dependent_yes: nil,
            second_member_claimed_as_dependent_by_names: nil,
          )
        end

        context "primary member claims a dependent" do
          it "checks 'claiming dependents' and lists names of dependents" do
            second_member = build(:member, tax_relationship: "Joint")
            dependent_member = build(
              :member,
              tax_relationship: "Dependent",
              first_name: "Baby",
            )
            create(
              :medicaid_application,
              filing_federal_taxes_next_year: true,
              filing_taxes_with_household_members: true,
              members: [
                build(
                  :member,
                  first_name: "Primo",
                  last_name: "Member",
                  tax_relationship: "Joint",
                ),
                second_member,
                dependent_member,
              ],
            )

            results = MedicaidApplicationAdditionalMemberTaxAttributes.new(
              member: second_member,
            ).to_h

            expect(results).to eq(
              second_member_filing_federal_taxes_next_year_yes: "Yes",
              second_member_tax_relationship_joint_yes: "Yes",
              second_member_joint_filing_member_name: "Primo Member",
              second_member_claiming_dependent_yes: "Yes",
              second_member_dependent_member_names: "Baby",
              second_member_claimed_as_dependent_yes: nil,
              second_member_claimed_as_dependent_by_names: nil,
            )
          end
        end
      end

      context "member is claimed as dependent by primary member" do
        it "checks 'is claimed as dependent' and lists primary member name" do
          dependent_member = build(
            :member,
            tax_relationship: "Dependent",
            first_name: "Baby",
          )
          create(
            :medicaid_application,
            filing_federal_taxes_next_year: true,
            filing_taxes_with_household_members: true,
            members: [
              build(:member, first_name: "Ben", tax_relationship: "Joint"),
              dependent_member,
            ],
          )

          results = MedicaidApplicationAdditionalMemberTaxAttributes.new(
            member: dependent_member,
          ).to_h

          expect(results).to eq(
            second_member_filing_federal_taxes_next_year_yes: nil,
            second_member_tax_relationship_joint_yes: nil,
            second_member_joint_filing_member_name: nil,
            second_member_claiming_dependent_yes: nil,
            second_member_dependent_member_names: nil,
            second_member_claimed_as_dependent_yes: "Yes",
            second_member_claimed_as_dependent_by_names: "Ben",
          )
        end

        it "checks 'is claimed as dependent', lists other joint member names" do
          dependent_member = build(
            :member,
            tax_relationship: "Dependent",
            first_name: "Baby",
          )
          create(
            :medicaid_application,
            filing_federal_taxes_next_year: true,
            filing_taxes_with_household_members: true,
            members: [
              build(:member, first_name: "Ben", tax_relationship: "Joint"),
              build(:member, first_name: "Jessie", tax_relationship: "Joint"),
              dependent_member,
            ],
          )

          results = MedicaidApplicationAdditionalMemberTaxAttributes.new(
            member: dependent_member,
          ).to_h

          expect(results).to eq(
            second_member_filing_federal_taxes_next_year_yes: nil,
            second_member_tax_relationship_joint_yes: nil,
            second_member_joint_filing_member_name: nil,
            second_member_claiming_dependent_yes: nil,
            second_member_dependent_member_names: nil,
            second_member_claimed_as_dependent_yes: "Yes",
            second_member_claimed_as_dependent_by_names: "Ben, Jessie",
          )
        end
      end

      context "member has no tax relationship with primary member" do
        it "does not return any fields" do
          member = build(
            :member,
            tax_relationship: nil,
          )
          create(
            :medicaid_application,
            members: [member],
          )

          results = MedicaidApplicationAdditionalMemberTaxAttributes.new(
            member: member,
          ).to_h

          expect(results).to eq({})
        end
      end
    end
  end
end
