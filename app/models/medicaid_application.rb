# frozen_string_literal: true

class MedicaidApplication < ApplicationRecord
  attribute :ssn
  attr_encrypted(
    :ssn,
    key: Rails.application.secrets.secret_key_for_ssn_encryption,
  )
end
