class IntroductionContactInformation < Step
  self.title = "Introduction"
  self.subhead = "Tell us the best ways to reach you."

  self.questions = {
    phone_number: "What is the best phone number to reach you?",
    accepts_text_messages: "May we send text messages to that phone number help you through the enrollment process?",
    email: "What is your email address?",
    street_address: "Address",
    city: "City",
    zip: "ZIP Code",
    mailing_address_same_as_home_address: "Is this address the same as your home address?",
  }

  self.placeholders = {
    phone_number: "Phone #",
    email: "youremail@email.com",
    street_address: "Street Address",
    city: "City",
    zip: "ZIP"
  }

  self.overviews = {
    street_address: "Where can we send you mail?"
  }

  self.help_messages = {
    email: "If you don’t have one or you don’t want to receive emails "\
      "from us you can leave this blank.",
    street_address: "This can be a street address or P.O. Box."
  }

  self.types = {
    accepts_text_messages: :yes_no,
    mailing_address_same_as_home_address: :yes_no
  }

  self.section_headers = {
    phone_number: "Phone",
    email: "Email",
    street_address: "Mail"
  }

  attr_accessor \
    :phone_number,
    :accepts_text_messages,
    :email,
    :street_address,
    :city,
    :zip,
    :mailing_address_same_as_home_address

  validates :email,
    format: {
      with: /\A.+@.+\..+\z/,
      message: "Make sure you enter a valid email address"
    },
    allow_blank: true

  validates :phone_number,
    length: { is: 10, message: "Make sure your phone number is 10 digits long" }

  validates :zip,
    length: { is: 5, message: "Make sure your ZIP code is 5 digits long" }

  validates \
    :accepts_text_messages,
    :street_address,
    :city,
    :mailing_address_same_as_home_address,
    presence: { message: "Make sure to answer this question" }

  before_validation :strip_non_digits_from_phone_number

  def assign_from_app
    assign_attributes(
      phone_number: @app.phone_number,
      accepts_text_messages: @app.accepts_text_messages,
      street_address: @app.mailing_street,
      city: @app.mailing_city,
      zip: @app.mailing_zip,
      mailing_address_same_as_home_address: @app
        .mailing_address_same_as_home_address,
      email: @app.email
    )
  end

  def update_app!
    @app.update!(
      phone_number: phone_number,
      accepts_text_messages: accepts_text_messages,
      mailing_address_same_as_home_address: mailing_address_same_as_home_address,
      mailing_street: street_address,
      mailing_city: city,
      mailing_zip: zip,
      email: email
    )

    unless @app.welcome_sms_sent
      Sms.new(@app).deliver_welcome_message
      @app.update! welcome_sms_sent: true
    end
  end

  def strip_non_digits_from_phone_number
    self.phone_number = phone_number.remove /[^\d]/
  end
end
