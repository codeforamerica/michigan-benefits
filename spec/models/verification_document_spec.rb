require "rails_helper"

describe VerificationDocument do
  describe "#file" do
    context "files are png/jpg format" do
      it "returns a tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = "http://example.com/test.jpg"
        raw_response_file = File.new("spec/fixtures/test_remote_image.jpg")
        stub_request(:get, document_url).to_return(raw_response_file)

        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )

        expect(document.file).to be_a(Tempfile)
      end
    end

    context "files are PDFs" do
      it "returns a tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = "http://example.com/test.pdf"
        raw_response_file = File.new("spec/fixtures/test_remote_pdf.pdf")
        stub_request(:get, document_url).to_return(raw_response_file)

        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )

        expect(document.file).to be_a(Tempfile)
      end
    end
  end
end
