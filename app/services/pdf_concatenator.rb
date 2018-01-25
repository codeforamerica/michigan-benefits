class PdfConcatenator
  def initialize(forms)
    @forms = forms
  end

  attr_reader :forms

  def run
    final_output_file = Tempfile.new(["final_output", ".pdf"], "tmp/")

    pdfs = forms.map do |form|
      PdfForms.new.fill_form(
        form.source_pdf_path,
        form.output_file.path,
        form.attributes,
      )
      form.output_file
    end

    PdfForms::PdftkWrapper.new.cat(*pdfs, final_output_file.path)
    final_output_file
  end
end
