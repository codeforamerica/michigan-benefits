# frozen_string_literal: true

class Views::Steps::PreferencesReminders < Views::Base
  needs :f

  def content
    slab_with_card do
      h3 'Would you like timely reminders to help you through the enrollment process?'

      help_text <<~TEXT
        You'll receive messages about key steps and ways to submit required
        documents. Let us know how you prefer to receive them. Select as many
        options as you like.
      TEXT

      question nil, nil, 'Text message me', 'checkbox', margin: false do
        checkbox_field f, :sms_reminders, 'Text message me'
      end

      question nil, nil, 'Email me', 'checkbox', margin: false do
        checkbox_field f, :email_reminders, 'Email me'
      end

      safety <<~TEXT
        No matter what, you will receive all official notices and legal
        information via post mail to the address you provided. These e-mail and
        text message reminders provide extra help.
      TEXT
    end
  end
end
