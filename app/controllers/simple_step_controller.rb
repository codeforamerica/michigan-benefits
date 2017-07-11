class SimpleStepController < ApplicationController
  layout 'simple_step'

  def allowed
    {
      edit: :member,
      update: :member
    }
  end

  private

  def step_params
    params.require(:step).permit(step_attrs)
  end

  def next_step
    step_path(StepNavigation.new(@step).next.to_param)
  end
end
