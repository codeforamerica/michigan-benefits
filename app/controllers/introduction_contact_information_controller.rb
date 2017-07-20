# frozen_string_literal: true

class IntroductionContactInformationController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      send_sms
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def send_sms
    return if current_app.welcome_sms_sent
    Sms.new(current_app).deliver_welcome_message
    current_app.update!(welcome_sms_sent: true)
  end
end
