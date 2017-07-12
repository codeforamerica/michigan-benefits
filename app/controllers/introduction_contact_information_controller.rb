# frozen_string_literal: true

class IntroductionContactInformationController < SimpleStepController
  def edit
    @step = step_class.new(
      current_app.attributes.slice(*step_attrs)
    )
  end

  def update
    @step = step_class.new(step_params)

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
end
