# frozen_string_literal: true

class StepsController < ApplicationController
  layout "step"

  before_action :maybe_skip, only: :edit
  before_action :ensure_application_present, only: :edit

  def self.to_param
    controller_path.dasherize
  end

  def self.step_class
    controller_path.classify.constantize
  rescue NameError
    NullStep
  end

  private

  delegate :step_class, to: :class

  def ensure_application_present
    if current_snap_application.blank?
      redirect_to root_path
    end
  end

  def step_params
    params.fetch(:step, {}).permit(*step_attrs)
  end

  def step_attrs
    step_class.attribute_names
  end

  def current_path(params = nil)
    step_path(self.class, params)
  end

  def maybe_skip
    if skip? && going_backwards?
      redirect_to previous_path(rel: "back")
    elsif skip?
      redirect_to next_path
    end
  end

  def skip?
    false
  end

  def previous_path(params = nil)
    previous_step = step_navigation.previous
    previous_step ? step_path(previous_step, params) : root_path
  end

  def going_backwards?
    params["rel"] == "back"
  end

  def next_path(params = nil)
    next_step = step_navigation.next
    step_path(next_step, params) if next_step
  end

  def skip_path(params = nil)
    skip_step = step_navigation.skip
    step_path(skip_step, params) if skip_step
  end

  def step_navigation
    @step_navigation ||= StepNavigation.new(self)
  end

  def array_to_checkboxes(array)
    array.map { |key| [key, true] }.to_h
  end

  def checkboxes_to_array(checkboxes)
    checkboxes.select { |k| step_params[k].in?(["1", 1, true]) }.map(&:to_s)
  end
end
