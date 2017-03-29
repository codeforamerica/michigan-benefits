class AdditionalIncome < Step
  self.title = "Money & Income"
  self.subhead = "Check all additional sources of income received by your household, if any."

  self.questions = {
    unemployment: "Unemployment insurance",
    ssi: "SSI or Disability",
    workers_comp: "Worker's compensation",
    pension: "Pension",
    social_security: "Social Security",
    child_support: "Child Support",
    foster_care: "Foster Care or Adoption Subsidies",
    other: "Other income",
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

  def previous
    if @app.income_change.present?
      IncomeChangeExplanation.new(@app)
    else
      IncomeChange.new(@app)
    end
  end

  def next
    LegalAgreement.new(@app)
  end

  def assign_from_app
    @app.additional_income.each do |checkbox|
      self.send("#{checkbox}=", true)
    end
  end

  def update_app!
    @app.update!(
      additional_income: checkboxes.select {|c| self.send(c) == "1" }.map(&:to_s),
    )
  end
end
