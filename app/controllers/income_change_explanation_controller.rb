# frozen_string_literal: true

class IncomeChangeExplanationController < SimpleStepController
  def edit
    @step = step_class.new(
      current_app.attributes.slice(*step_attrs)
    )
  end

  def update
    @step = step_class.new(step_params)
    current_app.update!(step_params)
    redirect_to next_path
  end

  private

  def skip?
    !current_app.income_change?
  end
end
