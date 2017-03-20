class IntroduceYourself < Step
  self.title = "Introduction"
  self.headline = "We're here to help"
  self.subhead = "To start, please introduce yourself."

  self.questions = {
    first_name: "What is your first name?",
    last_name: "What is your last name?",
    phone_number: "What is the best phone number to reach you?",
    accepts_text_messages: "May we send text messages to that phone number help you through the enrollment process?",
  }

  self.placeholders = {
    first_name: "First name",
    last_name: "Last name",
    phone_number: "555-555-5555"
  }

  self.types = {
    accepts_text_messages: :yes_no
  }

  attr_accessor :first_name, :last_name, :phone_number, :accepts_text_messages

  validates :first_name, presence: { message: "Make sure to provide a first name" }
  validates :last_name, presence: { message: "Make sure to provide a last name" }
  validates :phone_number, presence: { message: "Make sure your phone number is 10 digits long" }
  validates :accepts_text_messages, presence: { message: "Make sure to answer this question" }

  def previous
    nil
  end

  def next
    ChoosePrograms.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[first_name last_name phone_number accepts_text_messages])
  end

  def update_app!
    @app.update! first_name: first_name, last_name: last_name, phone_number: phone_number, accepts_text_messages: accepts_text_messages
  end
end
