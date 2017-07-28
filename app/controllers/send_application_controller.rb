# frozen_string_literal: true

class SendApplicationController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_snap_application.update(step_params)
      create_dhs1171_pdf
      send_email
      flash[:notice] = "You will receive an email with your filled out application attached in a few minutes."
      redirect_to root_path(anchor: "fold")
    else
      render :edit
    end
  end

  private

  def send_email
    ApplicationMailer.snap_application_notification(
      file_name: "tmp/#{new_file_name}",
      recipient_email: current_snap_application.email,
    ).deliver_later
  end

  def create_dhs1171_pdf
    Dhs1171Pdf.new(
      snap_application: current_snap_application,
      output_filename: new_file_name,
    ).save
  end

  def new_file_name
    "test_pdf.pdf"
  end
end
