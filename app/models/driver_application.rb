# frozen_string_literal: true

class DriverApplication < ApplicationRecord
  ENCRYPTION_KEY = Rails.application.secrets.secret_key_for_driver_application

  belongs_to :snap_application
  validates :snap_application, presence: true
  has_many :driver_errors, dependent: :destroy

  attribute :password
  attribute :secret_question_1_answer
  attribute :secret_question_2_answer
  attribute :user_id

  attr_encrypted(:user_id, key: ENCRYPTION_KEY)
  attr_encrypted(:password, key: ENCRYPTION_KEY)
  attr_encrypted(:secret_question_1_answer, key: ENCRYPTION_KEY)
  attr_encrypted(:secret_question_2_answer, key: ENCRYPTION_KEY)
end
