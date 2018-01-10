require "rails_helper"

RSpec.describe TimeZoneHelper do
  describe "#date_in_est" do
    it "returns date in Eastern Standard Time" do
      now = DateTime.new(2018, 1, 9, 3, 0, 0)
      date = TimeZoneHelper.date_in_est(now)

      expect(date).to eq(Date.new(2018, 1, 8))
    end
  end
end
