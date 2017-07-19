# frozen_string_literal: true

class PreferencesRemindersConfirmationController < StandardSimpleStepController
  private

  def skip?
    %i[sms_reminders email_reminders].none? { |k| current_app[k] }
  end
end
