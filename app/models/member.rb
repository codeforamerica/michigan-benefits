class Member < ApplicationRecord
  belongs_to :snap_application

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def full_name
    "#{first_name} #{last_name}"
  end

  def primary_member?
    snap_application.primary_member.id == id
  end

  def employed?
    employment_status == "employed"
  end

  def self_employed?
    employment_status == "self_employed"
  end
end
