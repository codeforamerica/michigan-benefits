class DescribeTaxRelationshipsForm < Form
  set_attributes_for :application, :members
  set_attributes_for :member, :tax_relationship

  validate :members_valid

  def members_valid
    members.each do |member|
      member.errors.clear
      validate_household_member(member)
    end

    return true if members.map(&:errors).all?(&:blank?)
    errors.add(:members, "Make sure to answer how you file taxes with each member")
  end

  private

  def validate_household_member(member)
    return if member.tax_relationship.present? && !member.tax_relationship_unfilled?
    member.errors.add(:tax_relationship, "Make sure you answer this question")
  end
end
