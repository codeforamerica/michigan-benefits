# frozen_string_literal: true

class IncomeOtherAssetsContinuedController < SimpleStepController
  def edit
    financial_accounts =
      current_app.financial_accounts.map { |key| [key, true] }.to_h

    @step = step_class.new(
      financial_accounts.merge(total_money: current_app.total_money)
    )
  end

  def update
    financial_accounts =
      step_params.except(:total_money).select { |_, value| value == '1' }.keys

    current_app.update!(
      total_money: step_params[:total_money],
      financial_accounts: financial_accounts
    )

    redirect_to next_path
  end

  private

  def skip?
    !current_app.has_accounts
  end
end
