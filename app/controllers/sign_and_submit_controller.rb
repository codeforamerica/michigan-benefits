# frozen_string_literal: true

class SignAndSubmitController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update(step_params)
      flash[:notice] = "Your application has been successfully submitted."
      redirect_to root_path(anchor: "fold")
    else
      render :edit
    end
  end
end
