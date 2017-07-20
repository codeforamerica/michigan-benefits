# frozen_string_literal: true

class StepsController < ApplicationController
  layout 'step'

  before_action :maybe_skip, only: :edit

  def self.to_param
    controller_path.dasherize
  end

  def self.step_class
    controller_path.classify.constantize
  end

  def allowed
    {
      index: :member,
      edit: :member,
      update: :member
    }
  end

  def index; end

  def edit
    @step = step_class.new
  end

  def update
    redirect_to next_path
  end

  private

  delegate :step_class, to: :class

  def array_to_checkboxes(array)
    array.map { |k| [k, true] }.to_h
  end

  def checkboxes_to_array(checkboxes)
    checkboxes.select { |k| step_params[k].in?(['1', 1, true]) }.map(&:to_s)
  end

  def maybe_skip
    return unless skip?

    if going_backwards?
      redirect_to previous_path(rel: 'back')
    else
      redirect_to next_path
    end
  end

  def skip?
    false
  end

  def going_backwards?
    params['rel'] == 'back'
  end

  def step_params
    params.fetch(:step, {}).permit(step_attrs)
  end

  def step_attrs
    step_class.attribute_names
  end

  def previous_path(params = nil)
    previous_step = step_navigation.previous
    previous_step ? step_path(previous_step, params) : root_path
  end

  def current_path(params = nil)
    step_path(self.class, params)
  end

  def next_path(params = nil)
    next_step = step_navigation.next
    step_path(next_step, params) if next_step
  end

  def step_navigation
    @step_navigation ||= StepNavigation.new(self)
  end
end
