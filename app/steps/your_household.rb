class YourHousehold < Step
  self.title = "Your Household"
  self.subhead = "Provide us with some personal details."

  self.questions = {
    birthday: "What is your date of birth?",
    sex: "What is your sex?",
    marital_status: "What is your marital status?",
    household_size: "How many people are in your household?"
  }

  self.types = {
    birthday: :date,
    sex: :radios,
    marital_status: :select,
    household_size: :incrementer
  }

  self.help_messages = {
    sex: "As it appears on your birth certificate",
    household_size: "This includes everyone who lives in your home (including you) and anyone you list on your federal tax returns."
  }

  self.field_options = {
    sex: ["male", "female"],
    marital_status: %w|Single Married Divorced Seperated|
  }

  attr_accessor \
    :birthday,
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
  end

  def update_app!
  end
end
