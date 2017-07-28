class Dhs1171Pdf
  SOURCE_PDF = "DHS_1171.pdf".freeze

  def initialize(snap_application)
    @snap_application = snap_application
  end

  def save(new_pdf_file_name)
    PdfForms.new.fill_form(SOURCE_PDF, new_pdf_file_name, client_data)
  end

  private

  attr_reader :snap_application, :source_pdf

  def client_data
    {
      applying_for_food_assistance: "Yes",
      full_name: snap_application.name,
      birth_day: snap_application.birthday.strftime("%d"),
      birth_month: snap_application.birthday.strftime("%m"),
      birth_year: snap_application.birthday.strftime("%Y"),
      street_address: snap_application.street_address,
      city: snap_application.city,
      county: snap_application.county,
      state: snap_application.state,
      zip: snap_application.zip,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
    }
  end
end
