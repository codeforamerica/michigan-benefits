class MedicaidApplicationAdditionalMemberTaxAttributes
  include PdfAttributes

  def initialize(member:)
    @member = member
  end

  def to_h
    if member.tax_relationship.blank?
      {}
    else
      {
        second_member_filing_federal_taxes_next_year_yes:
          bool_to_checkbox(filing_jointly?),
        second_member_tax_relationship_joint_yes:
          bool_to_checkbox(filing_jointly?),
        second_member_joint_filing_member_name: other_joint_filing_member_name,
        second_member_claiming_dependent_yes: bool_to_checkbox(dependents?),
        second_member_dependent_member_names: dependent_member_names,
        second_member_claimed_as_dependent_yes:
          bool_to_checkbox(claimed_as_dependent?),
        second_member_claimed_as_dependent_by_names:
          claimed_as_dependent_by_names,
      }
    end
  end

  private

  attr_reader :member

  def filing_jointly?
    member.tax_relationship == "Joint"
  end

  def claimed_as_dependent?
    member.tax_relationship == "Dependent"
  end

  def dependents?
    filing_jointly? && dependents.any?
  end

  def benefit_application
    member.benefit_application
  end

  def claimed_as_dependent_by_names
    if claimed_as_dependent?
      first_names(benefit_application.members.filing_taxes)
    end
  end

  def dependent_member_names
    if filing_jointly?
      first_names(dependents)
    end
  end

  def other_joint_filing_member_name
    if filing_jointly?
      other_joint_filing_member.display_name
    end
  end

  def other_joint_filing_member
    benefit_application.primary_member
  end
end
