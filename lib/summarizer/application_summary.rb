module Summarizer
  class ApplicationSummary
    def initialize(datetime, timezone)
      @date = datetime.in_time_zone(timezone)
      date_range = @date.beginning_of_day..@date.end_of_day
      @snap_applications = SnapApplication.where(created_at: date_range)
      @medicaid_applications = MedicaidApplication.where(created_at: date_range)
    end

    def daily_summary
      readable_date = @date.strftime("%a, %b %d")
      "On #{readable_date}, we processed #{snap_applications.count} SNAP "\
      "and #{medicaid_applications.count} Medicaid applications."
    end

    attr_reader :snap_applications, :medicaid_applications
  end
end
