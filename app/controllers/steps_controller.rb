class StepsController < ApplicationController
  def allowed
    {
      show: :member,
      update: :member
    }
  end

  def show
    @step = Step.find(params[:id], current_app)
    respond_with @step
  end

  def update
    @step = Step.find(params[:id], current_app)
    @step.update(step_params)
    respond_with @step, location: step_path(@step.next.to_param)
  end

  private

  def step_params
    params.require(:step).permit @step.questions.map(&:name)
  end

end
