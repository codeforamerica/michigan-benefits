class ExpensesAdditional < Step
  self.title = "Expenses"
  self.subhead = "Tell us more about the other expenses you listed."

  ATTRS = [
    :monthly_care_expenses,
    :childcare,
    :elderly_care,
    :disabled_adult_care,
    :monthly_medical_expenses,
    :health_insurance,
    :co_pays,
    :prescriptions,
    :dental,
    :in_home_care,
    :transportation,
    :hospital_bills,
    :other,
    :monthly_court_ordered_expenses,
    :child_support,
    :alimony,
    :monthly_tax_deductible_expenses,
    :student_loan_interest,
    :other_tax_deductible
  ]

  attr_accessor *ATTRS

  def allowed_params
    ATTRS.map(&:to_s)
  end

  def assign_from_app
    fields = @app.care_expenses +
      @app.medical_expenses +
      @app.court_ordered_expenses +
      @app.tax_deductible_expenses

    fields.each do |field|
      self.send("#{field}=", true)
    end

    assign_attributes @app.attributes.slice(*%w[
      monthly_care_expenses
      monthly_medical_expenses
      monthly_court_ordered_expenses
      monthly_tax_deductible_expenses
    ])
  end

  def update_app!
    @app.update!(
      monthly_care_expenses: monthly_care_expenses,
      care_expenses: check(care_expenses_checkboxes),
      monthly_medical_expenses: monthly_medical_expenses,
      medical_expenses: check(medical_expenses_checkboxes),
      monthly_court_ordered_expenses: monthly_court_ordered_expenses,
      court_ordered_expenses: check(court_ordered_expenses_checkboxes),
      monthly_tax_deductible_expenses: monthly_tax_deductible_expenses,
      tax_deductible_expenses: check(tax_deductible_expenses_checkboxes),
    )
  end

  def skip?
    !@app.dependent_care &&
      !@app.medical &&
      !@app.court_ordered &&
      !@app.tax_deductible
  end

  private

  def care_expenses_checkboxes
    [
      :childcare,
      :elderly_care,
      :disabled_adult_care
    ]
  end

  def medical_expenses_checkboxes
    [
      :health_insurance,
      :co_pays,
      :prescriptions,
      :dental,
      :in_home_care,
      :transportation,
      :hospital_bills,
      :other
    ]
  end

  def court_ordered_expenses_checkboxes
    [
      :child_support,
      :alimony
    ]
  end

  def tax_deductible_expenses_checkboxes
    [
      :student_loan_interest,
      :other_tax_deductible
    ]
  end
end
