class Views::Steps::PreferencesRemindersConfirmation < Views::Base
  needs :f, :app

  def content
    slab_with_card do
      if app.sms_reminders?
        div class: "with-padding-med" do
          text "We'll send text messages to you at "
          b number_to_phone app.phone_number
          text "."
        end
      end

      if app.email_reminders?
        question f, :email, "What's the best email address for you?" do
          text_field f, :email, "E-mail address"
        end
      end
    end
  end
end
