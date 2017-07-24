# frozen_string_literal: true

class StandardStepsController < StepsController
  def edit
    @step = step_class.new(
      current_app.attributes.slice(*step_attrs),
    )
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end
end
