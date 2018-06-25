module Summarizer
  class ApplicationSummary
    def initialize(datetime, timezone)
      @date = datetime.in_time_zone(timezone)
      date_range = @date.beginning_of_day..@date.end_of_day

      @integrated_applications = CommonApplication.
        where(created_at: date_range).
        signed
    end

    def daily_summary
      readable_date = @date.strftime("%a, %b %d")
      "On #{readable_date}, we processed #{integrated_applications.count} #{application_word}: "\
      "#{integrated_applications.applying_for_food_only.count} FAP-only, " \
      "#{integrated_applications.applying_for_healthcare_only.count} Medicaid-only, " \
      "and #{integrated_applications.applying_for_food_and_healthcare.count} for both programs."
    end

    attr_reader :integrated_applications

    private

    def application_word
      integrated_applications.count == 1 ? "application" : "applications"
    end
  end
end
