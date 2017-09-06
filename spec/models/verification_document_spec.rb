require "rails_helper"

describe VerificationDocument do
  describe "#file" do
    context "files are png/jpg format" do
      it "returns a tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = "https://example.com/images/drivers_license.jpg"
        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )
        allow(document).to receive(:open).with(document_url).and_return(
          File.open("spec/fixtures/test-pattern.png"),
        )

        expect(document.file).to be_a(Tempfile)
      end
    end

    context "files are PDFs" do
      it "returns a tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = Rails.root.join("spec/fixtures/test_pdf.pdf")

        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )

        expect(document.file).to be_a(Tempfile)
      end
    end
  end
end
