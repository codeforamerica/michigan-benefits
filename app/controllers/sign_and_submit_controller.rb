# frozen_string_literal: true

class SignAndSubmitController < StandardSimpleStepController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update!(step_params)
      FormMailer.submission(form: current_app.form).deliver_now
      Sms.new(current_app).deliver_submission_message
      redirect_to(next_path)
    else
      render :edit
    end
  end
end
