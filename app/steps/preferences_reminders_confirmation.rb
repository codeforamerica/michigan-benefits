# frozen_string_literal: true

class PreferencesRemindersConfirmation < Step
  step_attributes :email

  validates :email, presence: { message: 'Make sure to answer this question' }
end
