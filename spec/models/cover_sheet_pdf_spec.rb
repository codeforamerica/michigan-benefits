require "rails_helper"

RSpec.describe CoverSheetPdf do
  describe "#save" do
    it "saves a new coversheet pdf file" do
      file_name = "tmp/test_cover_sheet.pdf"

      expect(File.exists?(file_name)).to be_truthy
    end
  end
end
