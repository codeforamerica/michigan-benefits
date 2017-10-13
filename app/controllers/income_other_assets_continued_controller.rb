# frozen_string_literal: true

class IncomeOtherAssetsContinuedController < SnapStepsController
  def edit
    financial_accounts = array_to_checkboxes(
      current_application.financial_accounts,
    )

    @step = step_class.new(
      financial_accounts.merge(
        total_money: current_application.total_money,
      ),
    )
  end

  def update
    financial_accounts = checkboxes_to_array(
      step_params.except(:total_money).keys,
    )

    current_application.update!(
      total_money: step_params[:total_money],
      financial_accounts: financial_accounts,
    )

    redirect_to next_path
  end

  private

  def skip?
    !current_application.money_or_accounts_income?
  end
end
