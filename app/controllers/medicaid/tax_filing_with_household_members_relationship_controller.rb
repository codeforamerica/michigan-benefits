module Medicaid
  class TaxFilingWithHouseholdMembersRelationshipController <
    ManyMemberStepsController

    private

    def step
      @step ||= step_class.new(members: tax_household_members)
    end

    def skip?
      single_member_household? ||
        not_filing_federal_taxes_next_year ||
        not_filing_taxes_with_household_members
    end

    def primary_member_tax_relationship
      if step.members.map(&:tax_relationship).include?("Joint")
        "Joint"
      else
        "Single"
      end
    end

    def update_application
      super

      current_application.
        primary_member.
        update!(
          tax_relationship: primary_member_tax_relationship,
        )
    end

    def not_filing_federal_taxes_next_year
      !current_application.filing_federal_taxes_next_year?
    end

    def not_filing_taxes_with_household_members
      !current_application.filing_taxes_with_household_members?
    end

    def tax_household_members
      current_application.non_applicant_members.
        select(&:filing_taxes_with_primary_member)
    end

    def member_attrs
      %i[tax_relationship]
    end
  end
end
