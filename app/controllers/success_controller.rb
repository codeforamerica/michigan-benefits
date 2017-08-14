# frozen_string_literal: true

class SuccessController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update(step_params)
      create_and_send_pdf
      flash[:notice] = flash_notice
      redirect_to root_path(anchor: "fold")
    else
      render :edit
    end
  end

  def previous_path(*_args)
    nil
  end

  private

  def create_and_send_pdf
    SendApplicationJob.perform_later(snap_application: current_snap_application)
  end

  def flash_notice
    <<~eos
      You will receive an email with your filled out application attached in a
      few minutes.
    eos
  end
end
