class IncomeAdditionalSourcesController < SnapStepsController
  def edit
    @step = step_class.new(
      array_to_checkboxes(current_application.additional_income),
    )
  end

  def update
    current_application.update!(
      additional_income: checkboxes_to_array(step_params),
    )

    redirect_to next_path
  end

  private

  def step_class
    IncomeAdditionalSources
  end

  def checkboxes_to_array(checkboxes)
    checkboxes.select { |_, value| value == "1" }.keys
  end
end
