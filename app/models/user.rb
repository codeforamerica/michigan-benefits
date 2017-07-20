# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!

  before_save { email.try(:downcase!) }

  has_one :app

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, if: lambda {
    new_record? || changes[:crypted_password]
  }

  def full_name
    fields = app.applicant.attributes.values_at('first_name', 'last_name')
    fields.any?(&:present?) ? fields.join(' ') : 'Guest'
  end
end
