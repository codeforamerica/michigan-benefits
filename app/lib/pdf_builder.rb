class PdfBuilder
  def initialize(files:, output_file:)
    @files = files
    @output_file = output_file
  end

  def pdf
    Rails.logger.debug("Building a PDF out of #{paths_to_pdfs}")
    conjoin_files
    output_file
  end

  private

  attr_accessor :output_file, :files

  def conjoin_files
    system(
      "pdftk #{paths_to_pdfs}" +
      " cat output" +
      " #{output_file.path}",
    )
  end

  def paths_to_pdfs
    files.map(&:path).join(" ")
  end
end
