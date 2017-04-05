class IncomeFluctuation < ManyMemberUpdateStep
  self.title = "Money & Income"
  self.subhead = "Since their income fluctuates, tell us more about their annual income"

  self.member_grouped_questions = {
    expected_income_this_year: "Expected income this year",
    expected_income_next_year: "Expected income next year"
  }

  self.types = {
    expected_income_this_year: :money,
    expected_income_next_year: :money
  }

  self.help_messages = {
    expected_income_next_year: "If you think it will change"
  }

  def initialize(*args)
    super
    self.subhead = build_subhead
  end

  def skip?
    @app.household_members.all?(&:income_consistent?)
  end

  private

  def build_subhead
    "Since <span class='text--sky'>#{inconsistent_members}'s</span> income "\
      "fluctuates, tell us more about their annual income".html_safe
  end

  def inconsistent_members
    @app
      .household_members
      .find_all(&:income_inconsistent?)
      .map(&:name)
      .to_sentence
  end
end
