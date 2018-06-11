class Coversheet
  def fill?
    false
  end

  def output_file
    @_output_file ||= open("app/lib/pdfs/AssistanceApplication_CoverSheet.pdf")
  end
end
