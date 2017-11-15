module Medicaid
  class HealthIntroductionController < ApplicationController
    layout "step"
    before_action :ensure_application_present
    helper_method :current_application
    helper_method :application_title

    def self.to_param
      controller_path.dasherize
    end

    private

    def application_title
      "Medicaid Application"
    end

    def ensure_application_present
      return if current_application

      redirect_to root_path
    end

    def current_application
      MedicaidApplication.find_by(id: session[:medicaid_application_id])
    end

    def next_path(params = {})
      next_step = step_navigation.next
      decoded_step_path(step: next_step, params: params) if next_step
    end

    def previous_path(params = nil)
      previous_step = step_navigation&.previous
      if previous_step
        decoded_step_path(step: previous_step, params: params)
      else
        root_path
      end
    end

    def decoded_step_path(step: self.class, params: nil)
      step_path(step, params).gsub("%2F", "/")
    end

    def step_navigation
      @step_navigation ||= Medicaid::StepNavigation.new(self)
    end
  end
end
