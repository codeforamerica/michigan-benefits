class ExpensesHousing < Step
  self.title = "Expenses"
  self.subhead = "Tell us about your housing expenses."
  self.subhead_help = "Housing expenses help determine the amount of Food Assistance you may be eligible for."

  attr_accessor \
    :rent_expense,
    :property_tax_expense,
    :insurance_expense,
    :utility_heat,
    :utility_cooling,
    :utility_electrity,
    :utility_water_sewer,
    :utility_trash,
    :utility_phone,
    :utility_other

  validates \
    :rent_expense,
    :property_tax_expense,
    :insurance_expense,
    presence: { message: "Make sure to answer this question" }

  self.questions = {
    rent_expense: "How much does your household pay in rent or mortgage each month?",
    property_tax_expense: "How much do you pay in property tax each month?",
    insurance_expense: "How much do you pay in insurance each month?",
    utility_heat: 'Heat',
    utility_cooling: 'Cooling',
    utility_electrity: 'Electricity',
    utility_water_sewer: 'Water/Sewer',
    utility_trash: 'Trash Pickup',
    utility_phone: 'Phone',
    utility_other: 'Other'
  }

  self.types = {
    rent_expense: :money,
    property_tax_expense: :money,
    insurance_expense: :money,
    utility_heat: :checkbox,
    utility_cooling: :checkbox,
    utility_electrity: :checkbox,
    utility_water_sewer: :checkbox,
    utility_trash: :checkbox,
    utility_phone: :checkbox,
    utility_other: :checkbox
  }

  self.field_options = {
    utility_heat: FieldOption.form_group_no_bottom_space,
    utility_cooling: FieldOption.form_group_no_bottom_space,
    utility_electrity: FieldOption.form_group_no_bottom_space,
    utility_water_sewer: FieldOption.form_group_no_bottom_space,
    utility_trash: FieldOption.form_group_no_bottom_space,
    utility_phone: FieldOption.form_group_no_bottom_space,
    utility_other: FieldOption.form_group_no_bottom_space
  }

  self.help_messages = {
    utility_heat: <<-HELP_TEXT.html_safe
      <strong>What utilities do you pay?</strong>
      <br/>
      Only check utilities that are not included in your mortgage/rent payments.
    HELP_TEXT
  }

  def previous
    ExpensesIntroduction.new(@app)
  end

  def next
    SignAndSubmit.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      rent_expense
      property_tax_expense
      insurance_expense
      utility_heat
      utility_cooling
      utility_electrity
      utility_water_sewer
      utility_trash
      utility_phone
      utility_other
    ])
  end

  def update_app!
    @app.update!(
      rent_expense: rent_expense,
      property_tax_expense: property_tax_expense,
      insurance_expense: insurance_expense,
      utility_heat: utility_heat,
      utility_cooling: utility_cooling,
      utility_electrity: utility_electrity,
      utility_water_sewer: utility_water_sewer,
      utility_trash: utility_trash,
      utility_phone: utility_phone,
      utility_other: utility_other
    )
  end
end
