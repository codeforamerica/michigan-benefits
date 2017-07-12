class SimpleStepController < ApplicationController
  layout 'simple_step'

  before_action :maybe_skip, only: :edit

  def self.to_param
    controller_path.dasherize
  end

  def allowed
    {
      edit: :member,
      update: :member
    }
  end

  private

  def step_class
    controller_path.classify.constantize
  end

  def maybe_skip
    if skip?
      if going_backwards?
        redirect_to previous_path(rel: "back")
      else
        redirect_to next_path
      end
    end
  end

  def skip?
    false
  end

  def going_backwards?
    params["rel"] == "back"
  end

  def step_params
    params.require(:step).permit(step_attrs)
  end

  def step_attrs
    step_class.attributes
  end

  def previous_path(params=nil)
    step_path(step_navigation.previous.to_param, params)
  end

  def next_path
    step_path(step_navigation.next.to_param)
  end

  def step_navigation
    @step_navigation ||= StepNavigation.new(self)
  end
end
