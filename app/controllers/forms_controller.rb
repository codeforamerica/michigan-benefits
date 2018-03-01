class FormsController < ApplicationController
  layout "form"

  before_action :ensure_application_present, only: %i[edit update]

  helper_method :application_title

  def application_title
    "Food + Health Assistance"
  end

  def edit
    attribute_keys = Step::Attributes.new(form_attrs).to_sym
    @form = form_class.new(existing_attributes.slice(*attribute_keys))
  end

  def update
    @form = form_class.new(form_params)
    if @form.valid?
      update_models
      redirect_to(next_path)
    else
      render :edit
    end
  end

  def current_application
    CommonApplication.find_by(id: session[:current_application_id])
  end

  def current_path(params = nil)
    section_path(self.class.to_param, params)
  end

  def next_path(params = {})
    next_step = form_navigation.next
    section_path(next_step.to_param, params) if next_step
  end

  def previous_path(params = nil)
    previous_step = form_navigation.previous
    section_path(previous_step.to_param, params) if previous_step
  end

  def first_step_path
    before_you_start_sections_path
  end

  def self.form_class
    (controller_name + "_form").classify.constantize
  end

  def self.to_param
    controller_name.dasherize
  end

  def self.skip?(_)
    false
  end

  private

  delegate :form_class, to: :class

  # Override in subclasses

  def existing_attributes
    {}
  end

  def update_models; end

  # Don't override in subclasses

  def ensure_application_present
    if current_application.blank?
      redirect_to first_step_path
    end
  end

  def form_attrs
    form_class.attribute_names
  end

  def form_params
    params.fetch(:form, {}).permit(*form_attrs)
  end

  def form_navigation
    @form_navigation ||= FormNavigation.new(self)
  end

  def member_params
    form_params.except(*form_class.application_attributes)
  end

  def application_params
    form_params.slice(*form_class.application_attributes)
  end
end
