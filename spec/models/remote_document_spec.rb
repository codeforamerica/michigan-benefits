require "rails_helper"

describe RemoteDocument do
  describe "#download" do
    context "downloading public image" do
      it "writes to tempfile" do
        document_url = "https://bucket.s3.amazonaws.com/path/image.jpg"
        raw_response_file = File.new("spec/fixtures/test_remote_image.jpg")
        stub_request(:get, document_url).to_return(raw_response_file)

        downloaded = RemoteDocument.new(document_url).download

        expect(downloaded).not_to be_nil
        expect(file_type(downloaded.tempfile.path)).to eq "image/jpeg"
      end

      it "rotates the file if it is naturally landscape mode" do
        document_url = "https://bucket.s3.amazonaws.com/path/image.jpg"
        landscape_image_path = "spec/fixtures/image.jpg"
        stub_request(:get, document_url).to_return(
          body: File.read(landscape_image_path),
          status: 200,
        )

        downloaded = RemoteDocument.new(document_url).download
        imagemagick_file = MiniMagick::Image.open(downloaded.tempfile.path)

        expect(downloaded).not_to be_nil
        expect(imagemagick_file.width < imagemagick_file.height).to eq true
      end
    end

    context "downloading a private S3 image" do
      it "downloads the file with the AWS SDK instead" do
        bucket = "bucket"
        Rails.application.secrets.aws_bucket = bucket
        s3_object_path = "path/image.jpg"
        document_url = "https://#{bucket}.s3.amazonaws.com/#{s3_object_path}"
        stub_request(:get, document_url).
          to_raise(OpenURI::HTTPError.new("Error", nil))

        s3_fake = double(:s3, get_object: true)
        remote_document = RemoteDocument.new(document_url)
        allow(remote_document).to receive(:s3).and_return(s3_fake)

        downloaded = remote_document.download

        expect(downloaded).not_to be_nil
        expect(s3_fake).to have_received(:get_object).with(
          {
            bucket: bucket,
            key: s3_object_path,
          },
          target: downloaded.tempfile.path,
        )
      end
    end

    context "downloading a non-existent S3 object" do
      it "returns nil" do
        s3_fake = double(:s3)
        allow(s3_fake).to receive(:get_object).
          and_raise(Aws::S3::Errors::NoSuchKey.new("req", "resp"))

        document_url = "https://bucket.s3.amazonaws.com/s3_object_path"
        remote_document = RemoteDocument.new(document_url)
        allow(remote_document).to receive(:s3).and_return(s3_fake)

        stub_request(:get, document_url).
          to_raise(OpenURI::HTTPError.new("Error", nil))

        expect(remote_document.download).to be_nil
      end
    end
  end

  describe "#pdf?" do
    it "is true for a downloaded pdf" do
      document_url = "https://bucket.s3.amazonaws.com/path/image.pdf"
      raw_response_file = File.new("spec/fixtures/test_remote_pdf.pdf")
      stub_request(:get, document_url).to_return(raw_response_file)

      downloaded = RemoteDocument.new(document_url).download

      expect(downloaded.pdf?).to eq true
    end

    it "is false for a downloaded image" do
      document_url = "https://bucket.s3.amazonaws.com/path/image.jpg"
      raw_response_file = File.new("spec/fixtures/test_remote_image.jpg")
      stub_request(:get, document_url).to_return(raw_response_file)

      downloaded = RemoteDocument.new(document_url).download

      expect(downloaded.pdf?).to eq false
    end
  end

  def file_type(file_path)
    FileMagic.open(:mime) { |file_magic| file_magic.file(file_path, true) }
  end
end
