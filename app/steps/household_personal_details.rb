class HouseholdPersonalDetails < Step
  self.title = "Your Household"
  self.subhead = "Provide us with some personal details."

  validates :sex, :marital_status, :household_size, presence: { message: 'Make sure to answer this question.' }

  self.questions = {
    sex: "What is your sex?",
    marital_status: "What is your marital status?",
    ssn: "What is your social security number?",
    household_size: "How many people are in your household?"
  }

  self.types = {
    sex: :radios,
    marital_status: :select,
    household_size: :incrementer
  }

  self.help_messages = {
    sex: "As it appears on your birth certificate",
    ssn: "If you don't have one or don't want to answer now it's okay to skip this",
    household_size: "This includes everyone who lives in your home "\
      "(including you) and anyone you list on your federal tax returns."
    }

  self.field_options = {
    sex: %w|male female|,
    marital_status: %w|single married divorced separated|
  }

  self.placeholders = {
    ssn: "SSN"
  }

  attr_accessor \
    :sex,
    :marital_status,
    :household_size,
    :ssn

  def initialize(*_)
    super
    self.household_size ||= 1
  end

  def previous
    HouseholdIntroduction.new(@app)
  end

  def next
    if @app.household_size.to_i > 1
      HouseholdMembers.new(@app)
    else
      IncomeIntroduction.new(@app)
    end
  end

  def assign_from_app
    attrs = @app.attributes.slice('marital_status', 'household_size')
    self.assign_attributes(attrs)
    self.assign_attributes(@app.applicant.attributes.slice('sex', 'ssn'))
  end

  def update_app!
    ActiveRecord::Base.transaction do
      @app.update! \
        marital_status: marital_status,
        household_size: household_size

      @app.applicant.update! sex: sex, ssn: ssn
    end
  end
end
