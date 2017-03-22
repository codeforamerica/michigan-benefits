class ContactInformation < Step
  self.title = "Introduction"
  self.subhead = "Tell us the best ways to reach you."

  self.questions = {
    phone_number: "What is the best phone number to reach you?",
    accepts_text_messages: "May we send text messages to that phone number help you through the enrollment process?",
  }

  self.placeholders = {
    phone_number: "555-555-5555",
  }

  self.types = {
    accepts_text_messages: :yes_no
  }

  attr_accessor :phone_number, :accepts_text_messages

  validates :phone_number,
    length: { is: 10, message: "Make sure your phone number is 10 digits long" }

  validates :accepts_text_messages,
    presence: {message: "Make sure to answer this question"}

  before_validation :strip_non_digits_from_phone_number

  def previous
    IntroduceYourself.new(@app)
  end

  def next
    HomeAddress.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      phone_number
      accepts_text_messages
    ])
  end

  def update_app!
    @app.update!(
      phone_number: phone_number,
      accepts_text_messages: accepts_text_messages
    )
  end

  def strip_non_digits_from_phone_number
    self.phone_number = phone_number.remove /[^\d]/
  end
end
