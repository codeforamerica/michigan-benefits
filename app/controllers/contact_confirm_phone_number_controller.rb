# frozen_string_literal: true

class ContactConfirmPhoneNumberController < StandardStepsController
  include SnapFlow

  private

  def skip?
    !current_application&.sms_consented?
  end
end
