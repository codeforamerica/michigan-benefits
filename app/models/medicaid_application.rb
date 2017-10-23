# frozen_string_literal: true

class MedicaidApplication < ApplicationRecord
  has_many :members, as: :benefit_application, dependent: :destroy

  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )

  def self.step_navigation
    Medicaid::StepNavigation
  end

  def application_title
    "Medicaid Application"
  end

  def nobody_insured?
    !anyone_is_insured?
  end

  def primary_member
    members.order(:id).first || NullMember.new
  end

  def non_applicant_members
    members - [primary_member]
  end
end
