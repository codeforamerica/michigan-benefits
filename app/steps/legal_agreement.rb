class LegalAgreement < Step
  self.title = "Legal"
  self.subhead = "Scroll down to agree. You will sign on the next page."

  def previous
    IncomeOtherAssetsContinued.new(@app)
  end

  def next
    ExpensesIntroduction.new(@app)
  end

  def submit_label
    "I agree"
  end

  def assign_from_app
  end

  def update_app!
  end
end
