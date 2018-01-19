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

  def write_raw_pdf_to_temp_file(source:)
    temp_pdf = Tempfile.new("pdf", encoding: "ascii-8bit")
    temp_pdf << source
    temp_pdf
  end
end
