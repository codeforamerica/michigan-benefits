require "rails_helper"

describe PdfBuilder do
  describe "#pdf" do
    context "multiple files passed in" do
      it "concatenates the files" do
        output_file = Tempfile.new(["test", ".pdf"], "tmp/")
        pdf = File.open("spec/fixtures/test_pdf.pdf")
        second_pdf = File.open("spec/fixtures/test_pdf.pdf")

        pdf = PdfBuilder.new(
          file_paths: [pdf.path, second_pdf.path],
          output_file: output_file,
        ).pdf

        expect(pdf).to be_a(Tempfile)
        expect(PDF::Reader.new(pdf).page_count).to eq 2
      end
    end
  end
end
