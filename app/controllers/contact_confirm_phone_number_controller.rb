# frozen_string_literal: true

class ContactConfirmPhoneNumberController < StandardStepsController
  private

  def skip?
    !current_snap_application&.sms_consented?
  end
end
