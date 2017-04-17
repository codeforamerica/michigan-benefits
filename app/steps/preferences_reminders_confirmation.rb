class PreferencesRemindersConfirmation < Step
  include ActionView::Helpers::NumberHelper

  self.title = "Preferences"
  self.subhead = "Great! You'll receive a confirmation message soon."
  self.icon = "confirmation-message"

  attr_accessor \
    :email

  validates :email, presence: { message: "Make sure to answer this question" }

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      email
    ])
  end

  def allowed_params
    [ :email ]
  end

  def update_app!
    @app.update!(
      email: email
    )
  end

  def skip?
    ! @app.sms_reminders? && ! @app.email_reminders?
  end
end
