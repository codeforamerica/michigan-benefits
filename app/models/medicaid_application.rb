class MedicaidApplication < ApplicationRecord
  include Submittable
  include CommonBenefitApplication

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

  def residential_address
    addresses.where(mailing: false).first || NullAddress.new
  end

  def pdf
    @_pdf ||= Dhs1426Pdf.new(
      medicaid_application: self,
    ).completed_file
  end

  private

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
