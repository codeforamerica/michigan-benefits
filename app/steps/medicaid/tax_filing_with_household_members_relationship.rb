module Medicaid
  class TaxFilingWithHouseholdMembersRelationship < ManyMembersStep
    step_attributes(:members)

    validate :only_one_joint_filer

    private

    def only_one_joint_filer
      return true if members.map(&:tax_relationship).count("Joint") <= 1
      errors.add(
        :duplicate_joint_filers,
        "Make sure you only select one joint filer",
      )
    end

    def validate_household_member(_member)
      if _member.tax_relationship.empty?
        _member.errors.add(
          :tax_relationship,
          "Make sure you select one option",
        )
      end
    end
  end
end
