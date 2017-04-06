class PreferencesReminders < Step
  self.title = "Preferences"
  self.subhead = "We'll make sure you don't miss a thing. Tell us how to follow up with you."
  self.icon = "section-4"
  self.headline = "Almost done!"

  attr_accessor \
    :sms_reminders,
    :email_reminders

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      sms_reminders
      email_reminders
    ])
  end

  def allowed_params
    [ :sms_reminders, :email_reminders ]
  end

  def update_app!
    @app.update!(
      sms_reminders: sms_reminders,
      email_reminders: email_reminders,
    )
  end
end
