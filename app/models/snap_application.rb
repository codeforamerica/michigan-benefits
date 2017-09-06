class SnapApplication < ApplicationRecord
  has_many :addresses
  has_many :members

  scope :signed, -> { where.not(signed_at: nil) }
  scope :unfaxed, -> { where(faxed_at: nil) }
  scope :updated_awhile_ago, -> { where("updated_at < ?", 30.minutes.ago) }

  scope :faxable, -> { signed.unfaxed.updated_awhile_ago }

  def self.enqueue_faxes
    faxable.pluck(:id).each do |id|
      FaxApplicationJob.perform_later(snap_application_id: id)
    end
  end

  def pdf
    @pdf ||= Dhs1171Pdf.new(
      snap_application: self,
    ).completed_file
  end

  def monthly_gross_income
    [
      monthly_additional_income,
      members.map(&:monthly_income),
    ].flatten.compact.reduce(:+)
  end

  def monthly_additional_income
    [
      income_child_support,
      income_foster_care,
      income_other,
      income_pension,
      income_social_security,
      income_ssi_or_disability,
      income_unemployment_insurance,
      income_workers_compensation,
    ].flatten.compact.reduce(:+)
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def residential_address
    return mailing_address if mailing_address_same_as_residential_address?
    addresses.where.not(mailing: true).first || NullAddress.new
  end

  def full_name
    primary_member.full_name
  end

  def birthday
    primary_member.formatted_birthday
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end

  def faxed?
    faxed_at.present?
  end
end
