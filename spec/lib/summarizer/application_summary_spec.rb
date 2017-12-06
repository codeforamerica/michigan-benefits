require "rails_helper"
require "#{Rails.root}/lib/summarizer/application_summary"

RSpec.describe Summarizer::ApplicationSummary do
  describe "#run" do
    it "outputs a summary of applications for a given date" do
      date = Date.new(2017, 12, 1, 5)
      create_list(:snap_application, 2, created_at: date)
      create(:medicaid_application, created_at: date)

      create(:snap_application, created_at: date - 1.day)
      create(:medicaid_application, created_at: date + 1.day)

      text = Summarizer::ApplicationSummary.new(date).daily_summary
      expect(text).to eq(
        "On Fri, Dec 01, we processed 2 SNAP and 1 Medicaid applications.",
      )
    end
  end
end
