class MedicaidApplicationPrimaryMemberTaxAttributes
  include PdfAttributes

  def initialize(member:)
    @member = member
  end

  private

  attr_reader :member

  def attributes
    [
      {
        primary_member_joint_filing_member_name:
        other_joint_filing_member_name,
      },
      yes_no_checkbox(
        "primary_member_claimed_as_dependent",
        member.claimed_as_dependent?,
      ),
      yes_no_checkbox("primary_member_tax_relationship_joint", joint_filer?),
    ]
  end

  def other_joint_filing_member_name
    if other_joint_filing_member.present?
      other_joint_filing_member.display_name
    end
  end

  def other_joint_filing_member
    @_other_joint_filing_member ||=
      other_household_members.where(tax_relationship: "Joint").first
  end

  def other_household_members
    member.benefit_application.members.where.not(id: member.id)
  end

  def joint_filer?
    member.tax_relationship == "Joint"
  end
end
