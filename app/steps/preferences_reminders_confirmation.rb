# frozen_string_literal: true

class PreferencesRemindersConfirmation < SimpleStep
  step_attributes :email

  validates :email, presence: { message: 'Make sure to answer this question' }
end
