require "rails_helper"

describe VerificationDocument do
  include PdfHelper

  describe "pdf component" do
    let(:subject) do
      VerificationDocument.new(url: "nowhere.com", benefit_application: "nothing")
    end

    it_should_behave_like "pdf component"
  end

  describe "#fill?" do
    it "returns false" do
      document = VerificationDocument.new(url: "nowhere.com", benefit_application: "nothing")

      expect(document.fill?).to be_falsey
    end
  end

  describe "#output_file" do
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
          benefit_application: snap_application,
        )

        expect(document.output_file).to be_a(Tempfile)
        expect(pdf?(document.output_file.path)).to eq true
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
          benefit_application: snap_application,
        )

        expect(document.output_file).to be_a(Tempfile)
        expect(pdf?(document.output_file.path)).to eq true
      end
    end

    context "file does not successfully download" do
      it "returns nil" do
        remote_document = double("remote_document", download: nil)
        allow(RemoteDocument).to receive(:new).and_return(remote_document)

        document = VerificationDocument.new(
          url: "doc url",
          benefit_application: "snap application",
        )

        expect(document.output_file).to be_nil
      end
    end

    context "primary member has a nil birthday" do
      it "does not error" do
        medicaid_application = create(
          :medicaid_application,
          members: [build(:member, birthday: nil)],
        )
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
          benefit_application: medicaid_application,
        )

        expect(document.output_file).to be_a(Tempfile)
        expect(pdf?(document.output_file.path)).to eq true
      end
    end

    def temp_image_file
      Tempfile.new(["image", ".jpg"]).tap do |f|
        f.write(File.read("spec/fixtures/image.jpg"))
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
