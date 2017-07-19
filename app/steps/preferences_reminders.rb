# frozen_string_literal: true

class PreferencesReminders < SimpleStep
  step_attributes \
    :sms_reminders,
    :email_reminders
end
