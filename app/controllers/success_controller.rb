# frozen_string_literal: true

class SuccessController < SnapStepsController
  def previous_path(*_args)
    nil
  end

  def next_path
    after_submit_path
  end

  private

  def before_rendering_edit_hook
    return if !current_application.exportable?

    ExportFactory.create(
      destination: :sms,
      snap_application: current_application,
    )

    ExportFactory.create(
      destination: :office_email,
      snap_application: current_application,
    )

    DriveApplicationJob.perform_later(
      snap_application: current_application,
    )
  end

  def after_successful_update_hook
    flash[:notice] = flash_notice
    ExportFactory.create(
      destination: :client_email,
      snap_application: current_application,
    )
  end

  def flash_notice
    <<~NOTICE
      You will receive an email with your filled out application attached in a
      few minutes.
    NOTICE
  end
end
