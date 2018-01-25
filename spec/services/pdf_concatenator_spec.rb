require "rails_helper"

RSpec.describe PdfConcatenator do
  include PdfHelper

  describe "#run" do
    it "generates the form PDFs and concatenates the resulting files" do
      form_one = double("form one",
         source_pdf_path: "spec/fixtures/test_fillable_pdf.pdf",
         output_file: Tempfile.new,
         attributes: { anyone_buys_food_separately_names: "Luigi Tester" })

      form_two = double("form two",
        source_pdf_path: "spec/fixtures/test_fillable_pdf_2.pdf",
        output_file: Tempfile.new,
        attributes: { anyone_caretaker_names: "Christa Tester" })

      output_file = PdfConcatenator.new([form_one, form_two]).run
      expect(output_file).to be_a(Tempfile)
      expect(PDF::Reader.new(output_file).page_count).to eq 2

      result = filled_in_values(output_file.path)
      expect(result["anyone_buys_food_separately_names"]).to eq "Luigi Tester"
      expect(result["anyone_caretaker_names"]).to eq "Christa Tester"
    end
  end
end
