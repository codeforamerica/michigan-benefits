class Metrics
  def self.signups_per_week
    12.times.map do |i|
      start_date = 11.weeks.ago.beginning_of_week.to_date + i.weeks
      end_date = start_date + 6.days
      start_time = start_date.beginning_of_day
      end_time = end_date.end_of_day
      count = Account.where(created_at: (start_time..end_time)).count
      { start: start_date, finish: end_date, count: count }
    end
  end

  def self.signups_per_day
    7.times.map do |i|
      start_date = 6.days.ago.to_date + i.days
      start_time = start_date.beginning_of_day
      end_time = start_date.end_of_day
      count = Account.where(created_at: (start_time..end_time)).count
      { start: start_date, count: count }
    end
  end
end
