class VerificationDocument
  def initialize(url:, snap_application:)
    @url = url
    @snap_application = snap_application
  end

  def file
    downloaded_document = RemoteDocument.new(url).download
    return if downloaded_document.nil?
    return downloaded_document.tempfile if downloaded_document.pdf?

    tempfile = Tempfile.new([SecureRandom.hex, ".pdf"])
    pdf = Prawn::Document.new
    pdf.move_down 30
    add_header(pdf)
    pdf.image(downloaded_document.tempfile.path, fit: [500, 600])
    pdf.render_file(tempfile.path)
    tempfile
  end

  private

  attr_reader :url, :snap_application

  def add_header(pdf)
    pdf.font("Helvetica", size: 12) do
      pdf.text header
      pdf.move_down 10
    end
  end

  def header
    output = "Name:                  #{snap_application.display_name}\n"
    output += "Date of Birth:        #{snap_application.birthday}\n"
    output
  end
end
