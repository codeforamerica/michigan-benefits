class IncomeChangeExplanation < Step
  self.title = "Money & Income"
  self.subhead = "In your own words, tell us about the recent change in your household's income."
  self.subhead_help = "This will help us understand how to interpret other financial information."

  self.questions = {
    income_change_explanation: ["Explanation", :hidden],
  }

  self.types = {
    income_change_explanation: :text_area
  }

  self.placeholders = {
    income_change_explanation: "Explain here"
  }

  attr_accessor :income_change_explanation

  def previous
    IncomeChange.new(@app)
  end

  def next
    IncomeCurrentlyEmployed.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      income_change_explanation
    ])
  end

  def update_app!
    @app.update!(
      income_change_explanation: income_change_explanation,
    )
  end
end
