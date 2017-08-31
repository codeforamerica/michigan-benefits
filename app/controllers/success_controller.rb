# frozen_string_literal: true

class SuccessController < StandardStepsController
  def previous_path(*_args)
    nil
  end

  def next_path
    root_path(anchor: "fold")
  end

  private
  def before_rendering_edit
    FaxApplicationJob
      .perform_later(snap_application_id: current_snap_application.id)
  end

  def after_successful_update
    flash[:notice] = flash_notice
    EmailApplicationJob.
      perform_later(snap_application_id: current_snap_application.id)
  end

  def flash_notice
    <<~eos
      You will receive an email with your filled out application attached in a
      few minutes.
    eos
  end
end
