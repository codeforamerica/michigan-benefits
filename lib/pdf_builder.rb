require "open-uri"

class PdfBuilder
  # Files is either a collection of URIs or actual IO Streams
  def initialize(files:, filename:)
    @files = files
    @filename = filename
  end

  def pdf
    paths_to_pdfs = files.map(&method(:to_local_file)).
      map(&method(:convert_to_pdf)).
      compact.map(&:path)
    conjoin(paths_to_pdfs.join(" "))
    output_file
  end

  private

  attr_accessor :filename, :files

  def output_file
    @output_file ||= Tempfile.new([filename, ".pdf"], "tmp/")
  end

  def to_local_file(file)
    return open(file) unless file.respond_to?(:path)
    return file if file.respond_to?(:path)
  end

  def convert_to_pdf(file)
    file_type = MimeMagic.by_magic(file).try(:subtype).try(:upcase)

    if file_type == "PDF"
      file
    elsif %w(JPG JPEG PNG GIF).include?(file_type)
      convert_image_to_pdf(file)
    end
  end

  def convert_image_to_pdf(file)
    magick_object = MiniMagick::Image.open(file.path)

    pdf = Prawn::Document.new
    pdf.move_down 30
    pdf.font("Helvetica", size: 12) do
      pdf.text @header
      pdf.move_down 10
    end

    if magick_object.width > magick_object.height
      if @rotate
        magick_object.rotate("90")
      else
        magick_object.rotate("-90")
      end
    end
    pdf.image(magick_object.path, fit: [500, 600])

    tempfile = Tempfile.new([SecureRandom.hex, ".pdf"])
    pdf.render_file(tempfile.path)
    tempfile
  end

  def conjoin(paths_to_pdfs)
    system(
      "pdftk #{paths_to_pdfs}" +
    " cat output" +
    " #{output_file.path}",
    )
  end
end
