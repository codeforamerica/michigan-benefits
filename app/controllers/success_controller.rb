class SuccessController < SnapStepsController
  def previous_path(*_args)
    nil
  end

  def next_path
    after_submit_path
  end

  def edit
    super

    export
  end

  private

  def export
    ExportFactory.create(
      destination: :sms,
      benefit_application: current_application,
    )

    ExportFactory.create(
      destination: :office_email,
      benefit_application: current_application,
    )
  end

  def update_application
    super

    flash[:notice] = flash_notice
    ExportFactory.create(
      destination: :client_email,
      benefit_application: current_application,
    )
  end

  def flash_notice
    "Your application has been sent to your email inbox."
  end
end
