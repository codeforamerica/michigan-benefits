require "rails_helper"
require "#{Rails.root}/lib/summarizer/application_summary"

RSpec.describe Summarizer::ApplicationSummary do
  describe "#run" do
    it "returns a summary of daily applications for date and timezone" do
      date = DateTime.new(2017, 12, 1, 0, 0)
      create_list(:snap_application, 2, created_at: date)
      create(:medicaid_application, created_at: date)

      create(:snap_application, created_at: date - 1.day)
      create(:snap_application, created_at: date + 21.hours)
      create(:medicaid_application, created_at: date + 1.day)

      text = Summarizer::ApplicationSummary.new(
        date,
        "Europe/Samara", # +4 UTC Offset
      ).daily_summary

      expect(text).to eq(
        "On Fri, Dec 01, we processed 2 SNAP and 1 Medicaid applications.",
      )
    end
  end
end
