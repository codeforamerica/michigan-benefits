require "rails_helper"

describe VerificationDocument do
  describe "#file" do
    context "files are png/jpg format" do
      it "returns a pdf tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = "http://example.com/test.jpg"
        remote_document = double(
          :remote_document,
          tempfile: temp_image_file,
          pdf?: false,
        )
        allow(remote_document).to receive(:download).and_return(remote_document)
        allow(RemoteDocument).to receive(:new).and_return(remote_document)

        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )

        expect(document.file).to be_a(Tempfile)
        expect(pdf?(document.file.path)).to eq true
      end
    end

    context "files are PDFs" do
      it "returns a pdf tempfile" do
        snap_application = create(:snap_application, :with_member)
        document_url = "http://example.com/test.pdf"

        remote_document = double(:remote_document, pdf?: true)
        allow(remote_document).to receive(:tempfile).and_return(temp_pdf_file)
        allow(RemoteDocument).to receive_message_chain(:new, :download).
          and_return(remote_document)

        document = VerificationDocument.new(
          url: document_url,
          snap_application: snap_application,
        )

        expect(document.file).to be_a(Tempfile)
        expect(pdf?(document.file.path)).to eq true
      end
    end

    def temp_image_file
      Tempfile.new(["image", ".jpg"]).tap do |f|
        f.write(File.read("spec/fixtures/image.jpg"))
      end.tap(&:rewind)
    end

    def temp_pdf_file
      Tempfile.new(["doc", ".pdf"]).tap do |f|
        f.write(File.read("spec/fixtures/test_pdf.pdf"))
      end.tap(&:rewind)
    end

    def pdf?(file_path)
      mime_type = FileMagic.open(:mime) do |file_magic|
        file_magic.file(file_path, true)
      end

      mime_type.include?("pdf")
    end
  end
end
