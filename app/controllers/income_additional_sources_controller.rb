# frozen_string_literal: true

class IncomeAdditionalSourcesController < SimpleStepController
  def edit
    @step = step_class.new(
      current_app.additional_income.map { |key| [key, true] }.to_h
    )
  end

  def update
    current_app.update!(
      additional_income: step_params.select { |_, value| value == '1' }.keys
    )

    redirect_to next_path
  end
end
