# frozen_string_literal: true

class SendApplicationController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update(step_params)
      create_and_send_pdf
      redirect_to(next_path)
    else
      render :edit
    end
  end

  private

  def create_and_send_pdf
    SendApplicationJob.perform_later(snap_application: current_snap_application)
  end
end
