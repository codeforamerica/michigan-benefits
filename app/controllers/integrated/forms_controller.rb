module Integrated
  class FormsController < ApplicationController
    layout "form"

    helper_method :application_title

    def application_title
      "Food + Health Assistance"
    end

    def self.to_param
      controller_name.dasherize
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

    def current_path(params = nil)
      section_path(self.class.to_param, params)
    end

    def self.form_class
      (controller_name + "_form").classify.constantize
    end

    private

    delegate :form_class, to: :class

    def form_attrs
      form_class.attribute_names
    end

    def form_params
      params.fetch(:form, {}).permit(*form_attrs)
    end

    def existing_attributes; end

    def update_models; end

    def current_application
      CommonApplication.find_by(id: session[:current_application_id])
    end
  end
end
