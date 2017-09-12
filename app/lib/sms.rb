class Sms
  def initialize(snap_application)
    @snap_application = snap_application
  end

  def deliver_application_submitted_message
    deliver(
      "Your application for Food Assistance was submitted! The next step: an" +
      " interview w/ MDHHS staff. Expect a call soon. Reply to this msg any" +
      " time for more info.",
    )
  end

  private

  attr_reader :snap_application

  def deliver(body)
    if deliverable?
      Twilio::REST::Client.new.messages.create(
        to: snap_application.phone_number,
        from: twilio_phone_number,
        body: body,
      )
    end
  end

  def twilio_phone_number
    Rails.application.secrets.twilio_phone_number
  end

  def deliverable?
    unless twilio_phone_number.present?
      return undeliverable("TWILIO_PHONE_NUMBER not present")
    end

    unless snap_application.sms_consented
      return undeliverable(
        "applicant does not consent to receiving text messages",
      )
    end

    unless snap_application.phone_number.present?
      return undeliverable("app does not have a phone number")
    end

    true
  end

  def undeliverable(message)
    Rails.logger.warn("WARNING: SMS is undeliverable because #{message}")
    false
  end
end
