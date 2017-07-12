class IntroductionContactInformationController < SimpleStepController
  def edit
    @step = IntroductionContactInformation.new(
      current_app.attributes.slice(*step_attrs)
    )
  end

  def update
    @step = IntroductionContactInformation.new(step_params)

    if @step.valid?
      current_app.update!(step_params)

      unless current_app.welcome_sms_sent
        Sms.new(current_app).deliver_welcome_message
        current_app.update!(welcome_sms_sent: true)
      end

      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def step_attrs
    %w[
      phone_number
      accepts_text_messages
      mailing_street
      mailing_city
      mailing_zip
      mailing_address_same_as_home_address
      email
    ]
  end
end
