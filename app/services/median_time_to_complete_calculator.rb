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

    if applications.size.odd?
      (sorted_times[middle] / 60).round
    else
      ((sorted_times[middle - 1] + sorted_times[middle]) / 120).round
    end
  end

  private

  attr_reader :applications
end
