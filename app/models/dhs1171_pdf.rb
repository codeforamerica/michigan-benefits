class Dhs1171Pdf
  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1171.pdf".freeze
  COVERSHEET_PDF = "#{PDF_DIRECTORY}/michigan_snap_fax_cover_letter.pdf".freeze

  def initialize(snap_application:, output_filename: "test_output.pdf")
    @snap_application = snap_application
    @completed_filename = "tmp/completed#{output_filename}"
    @output_filename = "tmp/#{output_filename}"
  end

  def save
    fill_in_template_form
    add_cover_sheet_to_completed_form
  end

  private

  attr_reader :snap_application, :output_filename, :completed_filename

  def fill_in_template_form
    PdfForms.new.fill_form(SOURCE_PDF, completed_filename, client_data)
  end

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

  def add_cover_sheet_to_completed_form
    system(
      "pdftk #{COVERSHEET_PDF} #{completed_filename} cat output #{output_filename}",
    )
  end
end
