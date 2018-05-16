class MemberPerPageForm < Form
  validate :current_member_id_valid

  def valid_members=(members)
    @valid_members = members
  end

  def current_member_id_valid
    return true if @valid_members.map { |m| m.id.to_s }.include?(id)
    errors.add(:id, "Can't update that household member.")
    false
  end
end
