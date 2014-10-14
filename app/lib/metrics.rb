class Metrics
  class << self
    def signups_per_week
      count_per_week(Account, :created_at)
    end

    def signups_per_day
      count_per_day(Account, :created_at)
    end

    def lapsed
      lapsed_as_of = 11.weeks.ago
      lapsed = Account.
        where("last_activity_at < ? OR last_activity_at IS NULL", lapsed_as_of).
        count
      { start: -Date::Infinity.new, count: lapsed}
    end

    def churn_per_week
      count_per_week(Account, :last_activity_at)
    end

    def churn_per_day
      count_per_day(Account, :last_activity_at)
    end

    private

    def count_per_week(scope, attr)
      12.times.map do |i|
        start_time = (i+1).weeks.ago
        end_time = start_time + 7.days
        count = scope.where(attr => (start_time...end_time)).count
        { start: start_time, count: count }
      end
    end

    def count_per_day(scope, attr)
      7.times.map do |i|
        start_time = (i+1).days.ago
        end_time = start_time + 1.day
        count = scope.where(attr => (start_time...end_time)).count
        { start: start_time, count: count }
      end
    end
  end
end
