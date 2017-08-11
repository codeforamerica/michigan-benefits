class Dhs1171Pdf
  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1171.pdf".freeze
  COVERSHEET_PDF = "#{PDF_DIRECTORY}/michigan_snap_fax_cover_letter.pdf".freeze

  def initialize(snap_application:)
    @snap_application = snap_application
  end

  def completed_file
    complete_template_pdf_with_client_data
    prepend_cover_sheet_to_completed_form
    complete_form_with_cover
  ensure
    filled_in_form.close
    filled_in_form.unlink
  end

  private

  attr_reader :snap_application

  def complete_template_pdf_with_client_data
    PdfForms.new.fill_form(SOURCE_PDF, filled_in_form.path, client_data)
  end

  def filled_in_form
    @_filled_in_form ||= Tempfile.new(["snap_app", ".pdf"], "tmp/")
  end

  def client_data
    {
      applying_for_food_assistance: "Yes",
      full_name: snap_application.full_name,
      birth_day: snap_application.birthday.strftime("%d"),
      birth_month: snap_application.birthday.strftime("%m"),
      birth_year: snap_application.birthday.strftime("%Y"),
      street_address: snap_application.mailing_address.street_address,
      city: snap_application.mailing_address.city,
      county: snap_application.mailing_address.county,
      state: snap_application.mailing_address.state,
      zip: snap_application.mailing_address.zip,
      signature: snap_application.signature,
      signature_date: snap_application.signed_at,
    }
  end

  def prepend_cover_sheet_to_completed_form
    system("pdftk #{COVERSHEET_PDF} #{filled_in_form.path} cat output #{complete_form_with_cover.path}")
  end

  def complete_form_with_cover
    @_complete_form_with_cover ||=
      Tempfile.new(["snap_app_with_cover", ".pdf"], "tmp/")
  end
end
