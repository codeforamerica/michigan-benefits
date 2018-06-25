require "rails_helper"
require "#{Rails.root}/lib/summarizer/application_summary"

RSpec.describe Summarizer::ApplicationSummary do
  describe "#run" do
    it "returns a summary of daily applications for date and timezone" do
      date = DateTime.new(2017, 12, 1, 0, 0)

      create_list(:common_application, 2, :signed, :multi_member_food_and_healthcare, created_at: date)
      create(:common_application, :signed, :single_member_food, created_at: date)
      create(:common_application, :signed, :single_member_healthcare, created_at: date)

      create(:common_application, :signed, :single_member_food, created_at: date - 1.day)
      create(:common_application, :signed, :single_member_food, created_at: date + 21.hours)
      create(:common_application, :signed, :single_member_food, created_at: date + 1.day)

      text = Summarizer::ApplicationSummary.new(
        date,
        "Europe/Samara", # +4 UTC Offset
      ).daily_summary

      expect(text).to include(
        "On Fri, Dec 01, we processed 4 applications: 1 FAP-only, 1 Medicaid-only, and 2 for both programs",
      )
    end

    it "only includes signed applications" do
      date = DateTime.new(2017, 12, 1, 12, 0)

      create(:common_application, :unsigned, created_at: date)
      create(:common_application, :signed, created_at: date)

      text = Summarizer::ApplicationSummary.new(
        date,
        "America/New_York",
      ).daily_summary

      expect(text).to include(
        "On Fri, Dec 01, we processed 1 application:",
      )
    end
  end
end
