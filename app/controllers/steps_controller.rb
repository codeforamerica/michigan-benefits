# frozen_string_literal: true

class StepsController < ApplicationController
  include ApplicationHelper

  layout 'step'

  def allowed
    {
      index: :member,
      show: :member,
      update: :member
    }
  end

  def index; end

  def show # TODO: should be "edit"
    @app = current_app
    @step = find_step

    if @step.skip?
      if going_backwards?
        redirect_to previous_path(rel: 'back')
      else
        redirect_to next_path
      end
    else
      respond_with @step
    end
  end

  def update
    @step = find_step
    @step.update(step_params)

    if @step.valid?
      redirect_to next_path
    else
      @app = current_app
      render :show
    end
  end

  private

  def find_step
    Step.find(params[:id], current_app, params.slice('member_id'))
  end

  def next_path
    step_path(@step.next.to_param)
  end

  def previous_path(params = nil)
    step_path(@step.previous.to_param, params)
  end

  def going_backwards?
    params['rel'] == 'back'
  end

  def step_params
    if params.key?(:step)
      this_step_params = params.require(:step)

      if params['step'].key?('household_members')
        this_step_params.permit!
      else
        consolidate_multiparam_date_attrs!(this_step_params)
        this_step_params.permit(@step.allowed_params)
      end
    else
      {}
    end
  end

  def consolidate_multiparam_date_attrs!(params)
    multiparam_date_attrs = {}
    delete_params = []

    params.each do |key, val|
      # first capture is attr name, second is order
      multiparam_regex = /(\w+)\((\d)i\)/

      next unless key.match?(/\(\di\)/)
      puts key
      delete_params << key
      attr_name = key[multiparam_regex, 1]
      order = key[multiparam_regex, 2].to_i

      multiparam_date_attrs[attr_name] ||= []
      multiparam_date_attrs[attr_name][order] = val
    end

    delete_params.each { |param| params.delete(param) }

    multiparam_date_attrs.each do |key, vals|
      params[key] = Date.new(*vals.compact.map(&:to_i))
    end
  end
end
