class IncomeOtherAssetsContinued < Step
  self.title = "Money & Income"
  self.subhead = "Tell us more about those assets."

  self.questions = {
    total_money: "In total, how much money does your household have in cash and accounts?"
  }

  self.types = {
    total_money: :money
  }

  attr_accessor \
    :total_money

  validates \
    :total_money,
    presence: { message: "Make sure to answer this question" }

  def previous
    IncomeOtherAssets.new(@app)
  end

  def next
    LegalAgreement.new(@app)
  end

  def assign_from_app
    assign_attributes @app.attributes.slice(*%w[
      total_money
    ])
  end

  def update_app!
    @app.update!(
      total_money: total_money
    )
  end
end
