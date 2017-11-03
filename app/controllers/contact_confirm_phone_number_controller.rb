class ContactConfirmPhoneNumberController < SnapStepsController
  private

  def skip?
    !current_application&.sms_consented?
  end
end
