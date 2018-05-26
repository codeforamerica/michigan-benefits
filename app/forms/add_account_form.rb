class AddAccountForm < Form
  set_attributes_for :account,
                     :account_type, :institution, member_ids: []

  validate :member_ids_valid
  validates_presence_of :account_type, message: "Please choose the type of account."
  validates_presence_of :institution, message: "Please add a name for the bank or institution."

  def valid_members=(members)
    @valid_members = members
  end

  def member_ids_valid
    if member_ids.present?
      valid_member_ids = @valid_members.map do |member|
        member.id.to_s
      end
      return true if (member_ids - valid_member_ids).empty?
      errors.add(:member_ids, "Can only update members from this application")
    else
      errors.add(:member_ids, "Please select at least one person.")
    end
    false
  end
end
