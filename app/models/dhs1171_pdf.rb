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

  def initialize(client_data)
    @client_data = client_data
  end

  def save(new_pdf)
    check_for_invalid_fields
    PdfForms.new.fill_form(SOURCE_PDF, new_pdf, client_data)
  end

  private

  attr_reader :client_data, :source_pdf

  def check_for_invalid_fields
    raise "Invalid fields passed in: #{invalid_client_fields}" if invalid_client_fields.any?
  end

  def invalid_client_fields
    client_data.keys.map(&:to_s) - FIELDS
  end
end
