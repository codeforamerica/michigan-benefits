class MedicaidApplication < ApplicationRecord
  include Submittable

  has_many :members, as: :benefit_application, dependent: :destroy
  has_many :addresses, as: :benefit_application, dependent: :destroy

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def self.step_navigation
    Medicaid::StepNavigation
  end

  def nobody_insured?
    !anyone_insured?
  end

  def no_one_with_income?
    !anyone_with_income?
  end

  def anyone_with_income?
    anyone_employed? ||
      anyone_self_employed? ||
      anyone_other_income?
  end

  def nobody_married?
    !anyone_married?
  end

  def nobody_caretaker_or_parent?
    !anyone_caretaker_or_parent?
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end

  def residential_address
    return NullAddress.new if unstable_housing?
    return mailing_address if mailing_address_same_as_residential_address?
    addresses.where.not(mailing: true).first || NullAddress.new
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def pdf
    @pdf ||= Dhs1426Pdf.new(
      medicaid_application: self,
    ).completed_file
  end

  private

  def unstable_housing?
    !stable_housing?
  end
end
