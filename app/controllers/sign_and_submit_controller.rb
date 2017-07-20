# frozen_string_literal: true

class SignAndSubmitController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      send_submission_email
      send_submission_sms
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def send_submission_email
    FormMailer.submission(form: current_app.form).deliver_now
  end

  def send_submission_sms
    Sms.new(current_app).deliver_submission_message
  end
end
