class FormsController < ApplicationController
  layout "form"

  before_action :ensure_application_present, only: %i[edit update]

  helper_method :application_title

  def application_title(separator = " + ")
    if current_application&.navigator
      programs = []
      programs << "Food Assistance" if current_application.navigator.applying_for_food?
      programs << "Healthcare Coverage" if current_application.navigator.applying_for_healthcare?
      programs.join(separator)
    else
      "Food Assistance#{separator}Healthcare Coverage"
    end
  end

  def edit
    attribute_keys = Step::Attributes.new(form_attrs).to_sym
    @form = form_class.new(existing_attributes.slice(*attribute_keys))
  end

  def update
    assign_attributes_to_form
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
    root_path
  end

  def self.form_class
    (controller_name + "_form").classify.constantize
  end

  def self.to_param
    controller_name.dasherize
  end

  def self.skip?(application)
    return true if skip_rule_sets(application).any?
    custom_skip_rule_set(application)
  end

  def self.custom_skip_rule_set(_)
    false
  end

  def self.skip_rule_sets(_)
    []
  end

  private

  delegate :form_class, to: :class

  # Override in subclasses

  def existing_attributes
    {}
  end

  def assign_attributes_to_form
    @form = form_class.new(form_params)
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

  def params_for(model)
    attrs = form_class.attributes_for(model)
    form_params.slice(*Step::Attributes.new(attrs).to_s)
  end

  def combined_birthday_fields(day: nil, month: nil, year: nil)
    if [year, month, day].all? &:present?
      {
        birthday: DateTime.new(year.to_i, month.to_i, day.to_i),
      }
    else
      {}
    end
  end
end
