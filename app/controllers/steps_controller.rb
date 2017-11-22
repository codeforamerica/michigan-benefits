class StepsController < ApplicationController
  layout "step"

  before_action :ensure_application_present, only: %i(edit index update)
  before_action :maybe_skip, only: :edit

  helper_method :decoded_step_path
  helper_method :application_title

  def ensure_application_present
    if current_application.blank?
      redirect_to first_step_path
    end
  end

  def current_application
    snap_application || medicaid_application
  end

  def edit
    attribute_keys = Step::Attributes.new(step_attrs).to_sym
    @step = step_class.new(existing_attributes.slice(*attribute_keys))
  end

  def update
    @step = step_class.new(step_params)

    if @step.valid?
      update_application
      redirect_to(next_path)
    else
      render :edit
    end
  end

  def update_application
    current_application.update!(step_params)
  end

  def self.to_param
    controller_path.dasherize
  end

  def self.step_class
    controller_path.classify.constantize
  rescue NameError
    raise MiBridges::Errors::StepNotFoundError,
      "Step not found: #{controller_path.classify}. "\
      "Create the step or override `<controller>#step_class` "\
      "so that it returns `NullStep`"
  end

  def next_path(params = {})
    next_step = step_navigation.next
    decoded_step_path(step: next_step, params: params) if next_step
  end

  # This is an intentional noop
  def step_navigation; end

  # This is an intentional noop
  def application_title; end

  def snap_application
    SnapApplication.find_by(id: session[:snap_application_id])
  end

  def medicaid_application
    MedicaidApplication.find_by(id: session[:medicaid_application_id])
  end

  private

  delegate :step_class, to: :class

  def existing_attributes
    HashWithIndifferentAccess.new(current_application&.attributes)
  end

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
    previous_step = step_navigation&.previous
    if previous_step
      decoded_step_path(step: previous_step, params: params)
    else
      root_path
    end
  end

  def going_backwards?
    params["rel"] == "back"
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
