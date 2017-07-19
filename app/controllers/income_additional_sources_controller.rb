# frozen_string_literal: true

class IncomeAdditionalSourcesController < SimpleStepController
  def edit
    @step = step_class.new(
      array_to_checkboxes(current_app.additional_income)
    )
  end

  def update
    current_app.update!(
      additional_income: checkboxes_to_array(step_params.keys)
    )

    redirect_to next_path
  end
end
