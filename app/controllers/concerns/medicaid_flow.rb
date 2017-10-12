# frozen_string_literal: true

module MedicaidFlow
  def ensure_application_present
    if current_application.blank?
      redirect_to medicaid_intro_location_steps_path
    end
  end

  def current_application
    MedicaidApplication.find_by(id: current_medicaid_application_id)
  end

  def current_medicaid_application_id
    session[:medicaid_application_id]
  end

  def step_navigation
    @step_navigation ||= Medicaid::StepNavigation.new(self)
  end
end
