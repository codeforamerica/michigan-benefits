class MedicaidApplicationPrimaryMemberTaxAttributes
  include PdfAttributes

  def initialize(member:)
    @member = member
  end

  def to_h
    {
      joint_filer_key => "Yes",
      primary_member_joint_filing_member_name: other_joint_filing_member_name,
      claimed_as_dependent_key => "Yes",
    }
  end

  private

  attr_reader :member

  def claimed_as_dependent_key
    yes_or_no = yes_no(member.claimed_as_dependent?)
    :"primary_member_claimed_as_dependent_#{yes_or_no}"
  end

  def other_joint_filing_member_name
    if other_joint_filing_member.present?
      other_joint_filing_member.display_name
    end
  end

  def other_joint_filing_member
    other_household_members.where(tax_relationship: "Joint").first
  end

  def other_household_members
    member.benefit_application.members.where.not(id: member.id)
  end

  def joint_filer_key
    :"primary_member_tax_relationship_joint_#{yes_no(joint_filer?)}"
  end

  def joint_filer?
    member.tax_relationship == "Joint"
  end
end
