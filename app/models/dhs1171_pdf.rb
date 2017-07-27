class Dhs1171Pdf
  FIELDS = [
    "applying_for_food_assistance",
    "birth_day",
    "birth_month",
    "birth_year",
    "city",
    "county",
    "full_name",
    "signature",
    "signature_date",
    "state",
    "street_address",
    "zip",
  ].freeze

  PDF_DIRECTORY = "lib/pdfs".freeze
  SOURCE_PDF = "#{PDF_DIRECTORY}/DHS_1171.pdf".freeze
  COVERSHEET_PDF = "#{PDF_DIRECTORY}/michigan_snap_fax_cover_letter.pdf".freeze

  def initialize(client_data:, output_filename: "test_output.pdf")
    @client_data = client_data
    @working_filename = "tmp/working_#{output_filename}"
    @output_filename = "tmp/#{output_filename}"
  end

  def save
    check_for_invalid_fields
    fill_in_template_form
    add_cover_sheet_to_completed_form
  end

  private

  attr_reader :client_data, :output_filename, :working_filename

  def check_for_invalid_fields
    if invalid_client_fields.any?
      raise "Invalid fields passed in: #{invalid_client_fields}"
    end
  end

  def invalid_client_fields
    client_data.keys.map(&:to_s) - FIELDS
  end

  def fill_in_template_form
    PdfForms.new.fill_form(SOURCE_PDF, working_filename, client_data)
  end

  def add_cover_sheet_to_completed_form
    system(
      "pdftk #{COVERSHEET_PDF} #{working_filename} cat output #{output_filename}",
    )
  end
end
