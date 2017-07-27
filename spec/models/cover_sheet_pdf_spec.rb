require "rails_helper"

RSpec.describe CoverSheetPdf do
  describe "#save" do
    it "saves a new coversheet pdf file" do
      expect(file).to be_present
    end
  end
end
