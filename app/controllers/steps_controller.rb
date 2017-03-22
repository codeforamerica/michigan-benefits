class StepsController < ApplicationController
  def allowed
    {
      show: :member,
      update: :member
    }
  end

  def show # TODO: should be "edit"
    @step = Step.find(params[:id], current_app)
    respond_with @step
  end

  def update
    @step = Step.find(params[:id], current_app)
    @step.update(step_params)

    if @step.valid?
      redirect_to next_path
    else
      render :show
    end
  end

  def next_path
    next_path = @step.next
    (next_path.is_a? Step) ? step_path(next_path.to_param) : next_path
  end

  private

  def step_params
    params.require(:step).permit @step.questions.keys
  end
end
