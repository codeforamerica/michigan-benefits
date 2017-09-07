class PdfBuilder
  def initialize(file_paths:, output_file:)
    @file_paths = file_paths
    @output_file = output_file
  end

  def pdf
    Rails.logger.debug("Building a PDF out of #{paths_to_pdfs}")
    conjoin_files
    output_file
  end

  private

  attr_accessor :output_file, :file_paths

  def conjoin_files
    system(
      "pdftk #{paths_to_pdfs}" +
      " cat output" +
      " #{output_file.path}",
    )
  end

  def paths_to_pdfs
    file_paths.join(" ")
  end
end
