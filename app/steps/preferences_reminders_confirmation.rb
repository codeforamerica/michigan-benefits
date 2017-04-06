class PreferencesRemindersConfirmation < Step
  include ActionView::Helpers::NumberHelper

  self.title = "Preferences"
  self.subhead = "Great! You'll receive a confirmation message soon."
  self.icon = "confirmation-message"

  attr_accessor \
    :email

  validates :email, presence: { message: "Make sure to answer this question" }

  def subhead_help
    "We'll send text messages to you at <b>#{number_to_phone @app.phone_number}</b>.".html_safe
  end

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
end
