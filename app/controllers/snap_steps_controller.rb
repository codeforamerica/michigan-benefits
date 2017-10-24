# frozen_string_literal: true

class SnapStepsController < StepsController
  def ensure_application_present
    if current_application.blank?
      redirect_to introduce_yourself_steps_path
    end
  end

  def current_application
    SnapApplication.find_by(id: current_application_id)
  end

  def current_application_id
    session[:snap_application_id]
  end

  def set_current_application(application)
    session[:snap_application_id] = application.try(:id)
  end

  def step_navigation
    @step_navigation ||= StepNavigation.new(self)
  end

  def after_submit_path
    if current_application.office_location.present?
      public_send("#{current_application.office_location}_path", anchor: "fold")
    else
      root_path(anchor: "fold")
    end
  end
end
