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

  def initialize(client_info)
    @source_pdf = "DHS_1171.pdf"
    @client_info = client_info
  end

  def save(new_pdf)
    check_for_invalid_fields
    PdfForms.new.fill_form(source_pdf, new_pdf, client_info)
  end

  private

  attr_reader :client_info, :source_pdf

  def check_for_invalid_fields
    raise "Invalid fields passed in: #{invalid_client_fields}" if invalid_client_fields.any?
  end

  def invalid_client_fields
    client_info.keys.map(&:to_s) - FIELDS
  end
end
