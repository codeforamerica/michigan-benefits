# frozen_string_literal: true

class MedicaidApplication < ApplicationRecord
  has_many :members, as: :benefit_application, dependent: :destroy

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  attribute :last_four_ssn
  attr_encrypted(
    :last_four_ssn,
      key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def self.step_navigation
    Medicaid::StepNavigation
  end

  def nobody_insured?
    !anyone_insured?
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
end
