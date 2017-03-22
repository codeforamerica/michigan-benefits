class IntroduceYourself < Step
  self.icon = "hello"
  self.title = "Introduction"
  self.headline = "We're here to help."
  self.subhead = "To start, please introduce yourself."

  self.questions = {
    first_name: "What is your first name?",
    last_name: "What is your last name?",
  }

  self.placeholders = {
    first_name: "First name",
    last_name: "Last name",
  }

  self.types = {}

  attr_accessor :first_name, :last_name

  validates :first_name,
    presence: { message: "Make sure to provide a first name" }

  validates :last_name,
    presence: { message: "Make sure to provide a last name" }

  def previous
    nil
  end

  def next
    ContactInformation.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      first_name
      last_name
    ])
  end

  def update_app!
    @app.update!(
      first_name: first_name,
      last_name: last_name
    )
  end
end
