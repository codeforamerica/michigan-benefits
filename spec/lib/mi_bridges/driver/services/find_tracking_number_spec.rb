require "rails_helper"

RSpec.describe MiBridges::Driver::Services::FindTrackingNumber do
  describe "#run" do
    it "finds the tracking number" do
      tracking_number_from_fixture = "ABCD12345"
      file =
        File.read("spec/fixtures/view_track_and_print_your_application.html")

      tracking_number =
        MiBridges::Driver::Services::FindTrackingNumber.new(file).run

      expect(tracking_number).to eq tracking_number_from_fixture
    end
  end
end
