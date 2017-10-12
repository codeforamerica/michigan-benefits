# frozen_string_literal: true

class StepsController < ApplicationController
  include SnapFlow

  layout "step"

  before_action :ensure_application_present, only: %i(edit index)
  before_action :maybe_skip, only: :edit

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

  def step_params
    params.fetch(:step, {}).permit(*step_attrs)
  end

  def step_attrs
    step_class.attribute_names
  end

  def current_path(params = nil)
    decoded_step_path(params: params)
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
    if previous_step
      decoded_step_path(step: previous_step, params: params)
    else
      root_path
    end
  end

  def going_backwards?
    params["rel"] == "back"
  end

  def next_path(params = {})
    next_step = step_navigation.next
    decoded_step_path(step: next_step, params: params) if next_step
  end

  def skip_path(params = nil)
    skip_step = step_navigation.skip
    decoded_step_path(step: skip_step, params: params) if skip_step
  end

  def array_to_checkboxes(array)
    array.map { |key| [key, true] }.to_h
  end

  def checkboxes_to_array(checkboxes)
    checkboxes.select { |k| step_params[k].in?(["1", 1, true]) }.map(&:to_s)
  end

  def decoded_step_path(step: self.class, params: nil)
    step_path(step, params).gsub("%2F", "/")
  end
end
