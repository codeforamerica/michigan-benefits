class SnapApplication < ApplicationRecord
  has_many :addresses
  has_many :members

  def monthly_gross_income
    [
      income_child_support,
      income_foster_care,
      income_other,
      income_pension,
      income_social_security,
      income_ssi_or_disability,
      income_unemployment_insurance,
      income_workers_compensation,
      members.map(&:monthly_income),
    ].flatten.compact.reduce(:+)
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def residential_address
    addresses.where.not(mailing: true).first || NullAddress.new
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
