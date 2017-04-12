class HouseholdPersonalDetails < Step
  self.title = "Your Household"
  self.subhead = "Provide us with some personal details."

  validates :sex, :marital_status, presence: { message: 'Make sure to answer this question.' }

  self.questions = {
    sex: "What is your sex?",
    marital_status: "What is your marital status?",
    ssn: "What is your social security number?",
  }

  self.types = {
    sex: :radios,
    marital_status: :select,
  }

  self.help_messages = {
    sex: "As it appears on your birth certificate",
    ssn: "If you don't have one or don't want to answer now it's okay to skip this",
  }

  self.field_options = {
    sex: %w|male female|,
    marital_status: %w|single married divorced separated|
  }

  self.placeholders = {
    ssn: "SSN"
  }

  self.safeties = {
    ssn: <<~TEXT
      Social security numbers help ensure you receive the correct benefits. 
      MDHSS maintains strict security guidelines to protect the identities of 
      our residents.
    TEXT
  }

  attr_accessor \
    :sex,
    :marital_status,
    :ssn

  def assign_from_app
    attrs = @app.attributes.slice('marital_status')
    self.assign_attributes(attrs)
    self.assign_attributes(@app.applicant.attributes.slice('sex', 'ssn'))
  end

  def update_app!
    ActiveRecord::Base.transaction do
      @app.update! marital_status: marital_status

      @app.applicant.update! sex: sex, ssn: ssn
    end
  end
end
