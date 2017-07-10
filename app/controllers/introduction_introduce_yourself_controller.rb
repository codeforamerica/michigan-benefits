class IntroductionIntroduceYourselfController < ApplicationController
  layout 'step'

  def allowed
    {
      edit: :member,
      update: :member
    }
  end

  def edit
    @step = IntroductionIntroduceYourself.new
    @step.first_name = current_app.applicant.first_name
    @step.last_name = current_app.applicant.last_name
  end

  def update
    @step = IntroductionIntroduceYourself.new(step_params)

    if @step.valid?
      current_app.applicant.update!(
        first_name: @step.first_name,
        last_name: @step.last_name
      )

      redirect_to(next_step)
    else
      render :edit
    end
  end

  private

  def step_params
    params.require(:step).permit('first_name', 'last_name')
  end

  def next_step
    step_path(StepNavigation.new(@step).next.to_param)
  end
end
