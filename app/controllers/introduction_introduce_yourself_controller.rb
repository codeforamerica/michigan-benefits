class IntroductionIntroduceYourselfController < SimpleStepController
  def edit
    @step = IntroductionIntroduceYourself.new(
      current_app.applicant.attributes.slice(*step_attrs)
    )
  end

  def update
    @step = IntroductionIntroduceYourself.new(step_params)

    if @step.valid?
      current_app.applicant.update!(step_params)
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def step_attrs
    %w[
      first_name
      last_name
    ]
  end
end
