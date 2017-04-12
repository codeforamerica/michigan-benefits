class Sms
  def initialize(app)
    @app = app
  end

  def deliver_welcome_message
    deliver <<~TEXT
      Hi #{@app.applicant.name}! It takes ~15 min to finish this application. If you can't finish now, don't worry. Reply to this msg to pick up where you left off.

      Best,
      MDHHS
    TEXT
  end

  def deliver_submission_message
    deliver <<~TEXT
      Your application for Healthcare Coverage & Food Assistance was submitted! The next step: an interview w/ MDHSS staff. Reply to this msg any time for more info.
    TEXT
  end

  private

  def deliver(body)
    if deliverable?
      Twilio::REST::Client.new.messages.create(
        to: @app.phone_number,
        from: twilio_phone_number,
        body: body
      )
    end
  end

  def twilio_phone_number
    ENV["TWILIO_PHONE_NUMBER"]
  end

  def deliverable?
    return undeliverable("TWILIO_PHONE_NUMBER not present") unless twilio_phone_number.present?
    return undeliverable("app does not accept text messages") unless @app.accepts_text_messages
    return undeliverable("app does not have a phone number") unless @app.phone_number.present?

    if whitelist?
      return undeliverable("whitelist does not include phone number") unless whitelist.include?(@app.phone_number)
    end

    true
  end

  def whitelist?
    ENV.has_key? "TWILIO_RECIPIENT_WHITELIST"
  end

  def whitelist
    ENV["TWILIO_RECIPIENT_WHITELIST"].split
  end

  def undeliverable(message)
    Rails.logger.warn("WARNING: SMS is undeliverable because #{message}")
    false
  end
end
