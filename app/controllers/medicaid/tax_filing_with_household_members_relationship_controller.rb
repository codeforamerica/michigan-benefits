module Medicaid
  class TaxFilingWithHouseholdMembersRelationshipController <
    ManyMemberStepsController

    def update
      assign_household_member_attributes

      if step.valid?
        assign_primary_member_attributes
        update_application
        redirect_to(next_path)
      else
        render :edit
      end
    end

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

    def assign_primary_member_attributes
      primary_member = current_application.primary_member
      primary_member.assign_attributes(
        tax_relationship: primary_member_tax_relationship,
      )
      @step.members.push(primary_member)
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
