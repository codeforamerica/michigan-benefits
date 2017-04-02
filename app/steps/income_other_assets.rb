class IncomeOtherAssets < Step
  self.title = "Money & Income"
  self.subhead = "Tell us about the assets and money you have on hand."
  self.subhead_help = "If you don't know the answer to a question, that's okay."

  self.questions = {
    has_accounts: "Does your household have any money or accounts?"
    # has_home: "Does your household own any property or real estate?",
    # has_vehicle: "Does your household own any vehicles?"
  }

  self.help_messages = {
    has_accounts: "This includes Checking/Savings accounts, 401Ks, Trusts, Stocks, etc. You will be asked to verify by providing bank and account statements."
    # has_home: "You should include your primary home. But don't worry - it won't be counted against you",
    # has_vehicle: "Don't worry - your first vehicle will not be counted against you."
  }

  self.types = {
    has_accounts: :yes_no
    # has_home: :yes_no,
    # has_vehicle: :yes_no
  }

  attr_accessor \
    :has_accounts
    # :has_home
    # :has_vehicle

  validates \
    :has_accounts,
    # :has_home,
    # :has_vehicle,
    presence: { message: "Make sure to answer this question" }

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      has_accounts
    ])
  end

  def update_app!
    @app.update!(
      has_accounts: has_accounts,
      # has_home: has_home,
      # has_vehicle: has_vehicle
    )
  end
end
