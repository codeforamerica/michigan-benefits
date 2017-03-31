class HouseholdTax < Step
  self.title = "Your Household"

  self.questions = {
    household_tax: "Does anyone plan to file a federal tax return next year?"
  }

  self.help_messages = {
    household_tax: "You do not need to file a tax return to receive benefits."
  }

  self.types = {
    household_tax: :yes_no
  }

  attr_accessor \
    :household_tax

  validates \
    :household_tax,
    presence: { message: "Make sure to answer this question" }

  def previous
    HouseholdHealth.new(@app)
  end

  def next
    HouseholdTaxHow.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      household_tax
    ])
  end

  def update_app!
    @app.update!(
      household_tax: household_tax
    )
  end
end
