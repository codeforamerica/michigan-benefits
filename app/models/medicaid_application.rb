class MedicaidApplication < ApplicationRecord
  include Submittable

  has_many(
    :members,
    -> { order(created_at: :asc) },
    as: :benefit_application,
    dependent: :destroy,
  )

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

  def no_expenses?
    no_self_employment? &&
      no_child_support_alimony_arrears? &&
      no_student_loan_interest?
  end

  def nobody_married?
    !anyone_married?
  end

  def nobody_caretaker_or_parent?
    !anyone_caretaker_or_parent?
  end

  def display_name
    primary_member.display_name
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

  def residential_address
    addresses.where(mailing: false).first || NullAddress.new
  end

  def mailing_address
    addresses.where(mailing: true).first || NullAddress.new
  end

  def pdf
    @pdf ||= Dhs1426Pdf.new(
      medicaid_application: self,
    ).completed_file
  end

  def members_count
    members.count
  end

  private

  def unstable_housing?
    !stable_housing?
  end

  def no_self_employment?
    !anyone_self_employed?
  end

  def no_child_support_alimony_arrears?
    !anyone_pay_child_support_alimony_arrears?
  end

  def no_student_loan_interest?
    !anyone_pay_student_loan_interest?
  end
end
