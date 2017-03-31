class IncomeChildSupport < Step
  self.title = "Money & Income"
  self.subhead = "Tell us more about your additional income."

  self.questions = {
    child_support: "Monthly pay"
  }

  self.types = {
    child_support: :money
  }

  self.section_headers = {
    child_support: "Child Support",
  }

  attr_accessor \
    :child_support

  validates \
    :child_support,
    presence: { message: "Make sure to answer this question" }

  def previous
    IncomeAdditionalSources.new(@app)
  end

  def next
    IncomeOtherAssets.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      child_support
    ])
  end

  def update_app!
    @app.update!(
      child_support: child_support
    )
  end
end
