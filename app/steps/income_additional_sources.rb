class IncomeAdditionalSources < Step
  self.title = "Money & Income"
  self.subhead = "Check all additional sources of income received by your household, if any."

  self.questions = {
    unemployment: "Unemployment Insurance",
    ssi: "SSI or Disability",
    workers_comp: "Worker's Compensation",
    pension: "Pension",
    social_security: "Social Security",
    child_support: "Child Support",
    foster_care: "Foster Care or Adoption Subsidies",
    other: "Other Income",
  }

  self.types = {
    unemployment: :checkbox,
    ssi: :checkbox,
    workers_comp: :checkbox,
    pension: :checkbox,
    social_security: :checkbox,
    child_support: :checkbox,
    foster_care: :checkbox,
    other: :checkbox,
  }

  self.field_options = {
    unemployment:    FieldOption.form_group_no_bottom_space,
    ssi:             FieldOption.form_group_no_bottom_space,
    workers_comp:    FieldOption.form_group_no_bottom_space,
    pension:         FieldOption.form_group_no_bottom_space,
    social_security: FieldOption.form_group_no_bottom_space,
    child_support:   FieldOption.form_group_no_bottom_space,
    foster_care:     FieldOption.form_group_no_bottom_space,
    other:           FieldOption.form_group_no_bottom_space
  }

  attr_accessor \
    :unemployment,
    :ssi,
    :workers_comp,
    :pension,
    :social_security,
    :child_support,
    :foster_care,
    :other

  def checkboxes
    [
      :unemployment,
      :ssi,
      :workers_comp,
      :pension,
      :social_security,
      :child_support,
      :foster_care,
      :other,
    ]
  end

  def assign_from_app
    @app.additional_income.each do |checkbox|
      self.send("#{checkbox}=", true)
    end
  end

  def update_app!
    @app.update!(
      additional_income: check(checkboxes),
    )
  end
end
