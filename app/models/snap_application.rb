class SnapApplication < ApplicationRecord
  has_many :addresses
  has_many :members

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def full_name
    primary_member.full_name
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end
end
