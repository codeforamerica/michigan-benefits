class VerificationDocument
  def initialize(url:, snap_application:)
    @url = url
    @snap_application = snap_application
  end

  def file
    pdf = Prawn::Document.new
    magick_object = create_magick_object

    if magick_object.type == "PDF"
      magick_object.tempfile
    else
      pdf.move_down 30
      add_header(pdf)
      rotate_image(magick_object)

      pdf.image(magick_object.path, fit: [500, 600])
      tempfile = Tempfile.new([SecureRandom.hex, ".pdf"])
      pdf.render_file(tempfile.path)
      tempfile
    end
  end

  private

  attr_reader :url, :snap_application

  def create_magick_object
    MiniMagick::Image.open(local_file.path)
  end

  def local_file
    @_local_fle ||= MiniMagick::Image.open(url)
  end

  def add_header(pdf)
    pdf.font("Helvetica", size: 12) do
      pdf.text header
      pdf.move_down 10
    end
  end

  def rotate_image(magick_object)
    if magick_object.width > magick_object.height
      magick_object.rotate("-90")
    end
  end

  def header
    output = "Name:                  #{snap_application.full_name}\n"
    output += "Date of Birth:        #{snap_application.birthday}\n"
    output
  end
end
