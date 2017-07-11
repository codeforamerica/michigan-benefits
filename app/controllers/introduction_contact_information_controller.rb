class IntroductionContactInformationController < ApplicationController
  layout 'step'

  def allowed
    {
      edit: :member,
      update: :member
    }
  end

  def edit
    @step = IntroductionContactInformation.new(
      phone_number: current_app.phone_number,
      accepts_text_messages: current_app.accepts_text_messages,
      mailing_street: current_app.mailing_street,
      mailing_city: current_app.mailing_city,
      mailing_zip: current_app.mailing_zip,
      mailing_address_same_as_home_address: current_app
        .mailing_address_same_as_home_address,
      email: current_app.email
    )
  end

  def update
    @step = IntroductionContactInformation.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      redirect_to(next_step)
    else
      render :edit
    end
  end

  private

  def step_params
    params.require(:step).permit(%i[
      phone_number
      accepts_text_messages
      mailing_street
      mailing_city
      mailing_zip
      mailing_address_same_as_home_address
      email
    ])
  end

  def next_step
    step_path(StepNavigation.new(@step).next.to_param)
  end
end
