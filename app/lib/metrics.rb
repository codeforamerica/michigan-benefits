class Metrics
  class << self
    def signups_per_week
      count_per_week(Account, :created_at)
    end

    def signups_per_day
      count_per_day(Account, :created_at)
    end

    def churn_per_week
      lapsed = Account.where("last_activity_at < ?", 11.weeks.ago.beginning_of_week.beginning_of_day).count
      [{ start: -Date::Infinity.new, count: lapsed}] +
        count_per_week(Account, :last_activity_at)
    end

    def churn_per_day
      count_per_day(Account, :last_activity_at)
    end

    private

    def count_per_week(scope, attr)
      12.times.map do |i|
        start_date = i.weeks.ago.beginning_of_week.to_date
        end_date = start_date + 6.days
        start_time = start_date.beginning_of_day
        end_time = end_date.end_of_day
        count = scope.where(attr => (start_time..end_time)).count
        { start: start_date, count: count }
      end.reverse
    end

    def count_per_day(scope, attr)
      7.times.map do |i|
        start_date = i.days.ago.to_date
        start_time = start_date.beginning_of_day
        end_time = start_date.end_of_day
        count = scope.where(attr => (start_time..end_time)).count
        { start: start_date, count: count }
      end.reverse
    end
  end
end
