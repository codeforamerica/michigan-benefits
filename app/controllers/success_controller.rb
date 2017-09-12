# frozen_string_literal: true

class SuccessController < StandardStepsController
  def previous_path(*_args)
    nil
  end

  def next_path
    root_path(anchor: "fold")
  end

  private

  def before_rendering_edit_hook
    Export.create_and_enqueue(
      destination: :fax,
      snap_application: current_snap_application,
    )

    ApplicationSubmittedSmsJob.perform_later(
      snap_application: current_snap_application,
    )
  end

  def after_successful_update_hook
    flash[:notice] = flash_notice
    Export.create_and_enqueue(
      destination: :email,
      snap_application: current_snap_application,
    )
  end

  def flash_notice
    <<~eos
      You will receive an email with your filled out application attached in a
      few minutes.
    eos
  end
end
