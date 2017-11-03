class MedicaidStepsController < StepsController
  helper_method :single_member_household?

  def ensure_application_present
    if current_application.blank?
      redirect_to medicaid_intro_location_steps_path
    end
  end

  def current_application
    MedicaidApplication.find_by(id: current_medicaid_application_id)
  end

  def application_title
    "Medicaid Application"
  end

  def set_current_application(application)
    session[:medicaid_application_id] = application.try(:id)
  end

  def current_medicaid_application_id
    session[:medicaid_application_id]
  end

  def single_member_household?
    current_application.members.count == 1
  end

  def multi_member_household?
    current_application.members.count > 1
  end

  def step_navigation
    @step_navigation ||= Medicaid::StepNavigation.new(self)
  end
end
