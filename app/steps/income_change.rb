class IncomeChange < Step
  self.title = "Money & Income"
  self.subhead = "Has your household had a change in income in the past 30 days?"
  self.subhead_help = "This includes change of jobs, job loss, change in hours or wages, strikes, etc."

  self.questions = {
    income_change: ["Income change", :hidden],
  }

  self.types = {
    income_change: :yes_no
  }

  attr_accessor :income_change

  validates :income_change,
    presence: { message: "Make sure to answer this question" }

  def previous
    IncomeIntroduction.new(@app)
  end

  def next
    if @app.income_change?
      IncomeChangeExplanation.new(@app)
    else
      AdditionalIncome.new(@app)
    end
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      income_change
    ])
  end

  def update_app!
    @app.update!(
      income_change: income_change,
    )
  end
end
