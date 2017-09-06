class PdfBuilder
  def initialize(file_paths:, output_file:)
    @file_paths = file_paths
    @output_file = output_file
  end

  def pdf
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
