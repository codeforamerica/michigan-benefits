class YourHousehold < Step
  self.title = "Your Household"
  self.subhead = "Provide us with some personal details."

  validates :sex, :marital_status, :household_size, presence: { message: 'Make sure to answer this question.' }

  self.questions = {
    sex: "What is your sex?",
    marital_status: "What is your marital status?",
    household_size: "How many people are in your household?"
  }

  self.types = {
    sex: :radios,
    marital_status: :select,
    household_size: :incrementer
  }

  self.help_messages = {
    sex: "As it appears on your birth certificate",
    household_size: "This includes everyone who lives in your home "\
      "(including you) and anyone you list on your federal tax returns."
    }

  self.field_options = {
    sex: %w|male female|,
    marital_status: %w|single married divorced separated|
  }

  attr_accessor \
    :sex,
    :marital_status,
    :household_size

  def previous
    HouseholdIntroduction.new(@app)
  end

  def next
    LegalAgreement.new(@app)
  end

  def assign_from_app
    attrs = @app.attributes.slice('sex', 'marital_status', 'household_size')
    self.assign_attributes(attrs)
  end

  def update_app!
    @app.update! \
      sex: sex,
      marital_status: marital_status,
      household_size: household_size
  end
end
