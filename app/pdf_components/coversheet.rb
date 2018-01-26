class Coversheet
  def fill?
    false
  end

  def output_file
    @_output_file ||= open("app/lib/pdfs/DHS_1171_cover_letter.pdf")
  end
end
