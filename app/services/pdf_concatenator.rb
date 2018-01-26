class PdfConcatenator
  def initialize(components)
    @components = components
  end

  attr_reader :components

  def run
    final_output_file = Tempfile.new(["final_output", ".pdf"], "tmp/")

    pdfs = components.map do |component|
      if component.fill?
        PdfForms.new.fill_form(
          component.source_pdf_path,
          component.output_file.path,
          component.attributes,
        )
      end

      component.output_file
    end

    PdfForms::PdftkWrapper.new.cat(*pdfs, final_output_file.path)
    final_output_file
  end
end
