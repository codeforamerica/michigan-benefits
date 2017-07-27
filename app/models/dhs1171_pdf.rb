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

  SOURCE_PDF = "DHS_1171.pdf".freeze

  def initialize(client_data:, filename: "test_pdf.pdf")
    @client_data = client_data
    @filename = filename
  end

  def save
    check_for_invalid_fields
    PdfForms.new.fill_form(SOURCE_PDF, filename, client_data)
  end

  private

  attr_reader :client_data, :filename

  def check_for_invalid_fields
    if invalid_client_fields.any?
      raise "Invalid fields passed in: #{invalid_client_fields}"
    end
  end

  def invalid_client_fields
    client_data.keys.map(&:to_s) - FIELDS
  end
end
