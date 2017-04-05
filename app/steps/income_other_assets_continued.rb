class IncomeOtherAssetsContinued < Step
  self.title = "Money & Income"
  self.subhead = "Tell us more about those assets."

  self.questions = {
    total_money: "In total, how much money does your household have in cash and accounts?",
    checking_account: "Checking account",
    savings_account: "Savings account",
    four_oh_one_k: "401k",
    life_insurance: "Life insurance",
    iras: "IRAs",
    mutual_funds: "Mutual funds",
    stocks: "Stocks",
    trusts: "Trusts"
  }

  self.types = {
    total_money: :money,
    checking_account: :checkbox,
    savings_account: :checkbox,
    four_oh_one_k: :checkbox,
    life_insurance: :checkbox,
    iras: :checkbox,
    mutual_funds: :checkbox,
    stocks: :checkbox,
    trusts: :checkbox
  }

  self.overviews = {
    checking_account: "What kind of accounts or assets do you have?"
  }


  self.field_options = {
    checking_account: FieldOption.form_group_no_bottom_space,
    savings_account: FieldOption.form_group_no_bottom_space,
    four_oh_one_k: FieldOption.form_group_no_bottom_space,
    life_insurance: FieldOption.form_group_no_bottom_space,
    iras: FieldOption.form_group_no_bottom_space,
    mutual_funds: FieldOption.form_group_no_bottom_space,
    stocks: FieldOption.form_group_no_bottom_space,
    trusts: FieldOption.form_group_no_bottom_space
  }

  attr_accessor \
    :total_money,
    :checking_account,
    :savings_account,
    :four_oh_one_k,
    :life_insurance,
    :iras,
    :mutual_funds,
    :stocks,
    :trusts

  validates \
    :total_money,
    presence: { message: "Make sure to answer this question" }

  def checkboxes
    [
      :checking_account,
      :savings_account,
      :four_oh_one_k,
      :life_insurance,
      :iras,
      :mutual_funds,
      :stocks,
      :trusts
    ]
  end

  def assign_from_app
    @app.financial_accounts.each do |checkbox|
      self.send("#{checkbox}=", true)
    end

    assign_attributes @app.attributes.slice(*%w[
      total_money
    ])
  end

  def update_app!
    @app.update!(
      total_money: total_money,
      financial_accounts: checkboxes.select {|c| self.send(c) == "1" }.map(&:to_s)
    )
  end
end
