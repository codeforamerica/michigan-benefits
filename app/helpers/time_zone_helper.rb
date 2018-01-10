module TimeZoneHelper
  class << self
    def date_in_est(datetime)
      datetime.
        in_time_zone("Eastern Time (US & Canada)").
        to_date
    end
  end
end
