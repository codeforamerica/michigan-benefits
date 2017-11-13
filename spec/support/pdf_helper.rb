module PdfHelper
  def filled_in_values(file:)
    filled_in_fields = pdftk.get_fields(file)

    filled_in_fields.each_with_object({}) do |field, hash|
      hash[field.name] = field.value
    end
  end

  def pdftk
    @_pdftk ||= PdfForms.new
  end

  def write_response_to_temp_file
    temp_pdf = Tempfile.new("pdf")
    temp_pdf << page.source.force_encoding("UTF-8")
    temp_pdf
  end
end
