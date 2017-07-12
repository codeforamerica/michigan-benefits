class IntroductionCompleteController < SimpleStepController
  def edit
    @step = step_class.new(first_name: current_app.applicant.first_name)
  end

  def update
    redirect_to next_path
  end
end
