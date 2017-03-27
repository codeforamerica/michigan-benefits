class HomeAddress < Step
  self.title = "Introduction"
  self.subhead = "Tell us where you currently live."

  self.questions = {
    home_address: "Street",
    home_city: "City",
    home_zip: "ZIP Code",
    unstable_housing: "Check if you do not have stable housing.",
  }

  self.placeholders = {
    home_address: "Street",
    home_city: "City",
    home_zip: "ZIP",
  }

  self.overviews = {
    home_address: "What is your home address?"
  }

  self.types = {
    unstable_housing: :checkbox
  }

  attr_accessor \
    :home_address,
    :home_city,
    :home_zip,
    :unstable_housing

  validates :home_zip,
    length: {is: 5, message: "Make sure your ZIP code is 5 digits long"},
    unless: -> (home_address) { home_address.unstable_housing.in? ["1", "true", true] }

  validates \
    :home_address,
    :home_city,
    presence: { message: "Make sure to answer this question" },
    unless: -> (home_address) { home_address.unstable_housing.in? ["1", "true", true] }

  def previous
    ContactInformation.new(@app)
  end

  def next
    IntroductionComplete.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      home_address
      home_city
      home_zip
      unstable_housing
    ])
  end

  def update_app!
    @app.update!(
      home_address: home_address,
      home_city: home_city,
      home_zip: home_zip,
      unstable_housing: unstable_housing,
    )
  end
end
