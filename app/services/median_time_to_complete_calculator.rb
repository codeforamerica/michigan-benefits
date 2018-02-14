class MedianTimeToCompleteCalculator
  def initialize(applications)
    @applications = applications
  end

  def run
    return if applications.empty?

    sorted_times = applications.
      map { |a| a.signed_at - a.created_at }.
      sort

    middle = (sorted_times.length / 2).floor

    median_time = if applications.size.odd?
                    sorted_times[middle]
                  else
                    (sorted_times[middle - 1] + sorted_times[middle]) / 2
                  end
    median_minutes = (median_time / 60).floor.abs
    median_seconds = (median_time % 60).floor
    "#{median_minutes}m #{median_seconds}s"
  end

  private

  attr_reader :applications
end
