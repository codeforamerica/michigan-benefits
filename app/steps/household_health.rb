class HouseholdHealth < Step
  self.title = "Your Household"
  self.subhead = "Tell us about your household health coverage in the past 3 months."

  self.questions = {
    any_medical_bill_help_last_3_months: "Does anyone need help paying for medical bills from the past 3 months?",
    any_lost_insurance_last_3_months: "Did anyone have insurance through a job and lose it in the last 3 months?",
  }

  self.help_messages = {
    any_lost_insurance_last_3_months: "Including Medicaid, CHIP/MIChild, Medicare, VA Healthcare Programs, Peace Corps, Employer Insurance, TRICARE (unless you have direct care or Line of Duty), and Other."
  }

  self.types = {
    any_medical_bill_help_last_3_months: :yes_no,
    any_lost_insurance_last_3_months: :yes_no
  }

  attr_accessor \
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months

  validates \
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months,
    presence: { message: "Make sure to answer this question" }

  def previous
    HouseholdMeta.new(@app)
  end

  def next
    HouseholdTax.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      any_medical_bill_help_last_3_months
      any_lost_insurance_last_3_months
    ])
  end

  def update_app!
    @app.update!(
      any_medical_bill_help_last_3_months: any_medical_bill_help_last_3_months,
      any_lost_insurance_last_3_months: any_lost_insurance_last_3_months
    )
  end
end
