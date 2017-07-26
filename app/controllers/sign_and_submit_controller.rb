# frozen_string_literal: true

class SignAndSubmitController < StandardStepsController
  def update
    @step = step_class.new(step_params)

    if @step.valid?
      current_app.update(step_params)
      create_dhs1171_pdf
      flash[:notice] = "Your application has been successfully submitted."
      redirect_to root_path(anchor: "fold")
    else
      render :edit
    end
  end

  private

  def create_dhs1171_pdf
    data = {
      applying_for_food_assistance: "Yes",
      full_name: current_app.name,
      birth_day: current_app.birthday.strftime("%d"),
      birth_month: current_app.birthday.strftime("%m"),
      birth_year: current_app.birthday.strftime("%Y"),
      street_address: current_app.street_address,
      city: current_app.city,
      county: current_app.county,
      state: current_app.state,
      zip: current_app.zip,
      signature: current_app.signature,
      signature_date: current_app.signed_at,
    }

    Dhs1171Pdf.new(data).save("test_pdf.pdf")
  end
end
