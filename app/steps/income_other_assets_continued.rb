# frozen_string_literal: true

class IncomeOtherAssetsContinued < Step
  step_attributes(
    :checking_account,
    :four_oh_one_k,
    :iras,
    :life_insurance,
    :mutual_funds,
    :other,
    :savings_account,
    :stocks,
    :total_money,
    :trusts,
  )
end
