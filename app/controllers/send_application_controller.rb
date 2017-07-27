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
      file_name: new_file_name,
      recipient_email: current_snap_application.email,
    ).deliver
  end

  def create_dhs1171_pdf
    data = {
      applying_for_food_assistance: "Yes",
      full_name: current_snap_application.name,
      birth_day: current_snap_application.birthday.strftime("%d"),
      birth_month: current_snap_application.birthday.strftime("%m"),
      birth_year: current_snap_application.birthday.strftime("%Y"),
      street_address: current_snap_application.street_address,
      city: current_snap_application.city,
      county: current_snap_application.county,
      state: current_snap_application.state,
      zip: current_snap_application.zip,
      signature: current_snap_application.signature,
      signature_date: current_snap_application.signed_at,
    }

    Dhs1171Pdf.new(data).save(new_file_name)
  end

  def new_file_name
    "test_pdf.pdf"
  end
end
