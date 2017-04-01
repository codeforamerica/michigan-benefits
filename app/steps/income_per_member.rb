class IncomePerMember < ManyMemberUpdateStep
  self.title = "Money & Income"
  self.subhead = "Tell us more about your household's employment"

  self.member_grouped_questions = {
    employer_name: "Employer name",
    hours_per_week: "Usual hours per week",
    pay_quantity: "Pay (before tax)",
    pay_interval: "per",
    income_consistent: "Is this income consistent month-to-month?"
  }

  self.types = {
    employer_name: :text,
    hours_per_week: :number,
    pay_quantity: :money,
    pay_interval: :select,
    income_consistent: :yes_no
  }

  self.placeholders = {
    employer_name: 'Employer'
  }

  self.help_messages = {
    pay_quantity: 'This includes money withheld from paychecks'
  }

  self.field_options = {
    pay_interval: %w[day week 2-weeks month]
  }

  def previous
    IncomeCurrentlyEmployed.new(@app)
  end

  def next
    IncomeAdditionalSources.new(@app)
  end
end
