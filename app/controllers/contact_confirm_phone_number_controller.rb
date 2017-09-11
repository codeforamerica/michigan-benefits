# frozen_string_literal: true

class ContactConfirmPhoneNumberController < StandardStepsController
  private

  def skip?
    current_snap_application && !current_snap_application.sms_subscribed?
  end
end
