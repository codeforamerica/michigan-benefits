class FunnelStage
  attr_reader :name, :cohort, :previous_cohort

  def initialize(name:, cohort:, previous_cohort:)
    @name = name
    @cohort = cohort
    @previous_cohort = previous_cohort
  end

  def count
    cohort.length
  end

  def previous_count
    previous_cohort.length
  end

  def conversion_rate
    return 1 if previous_count.zero?
    count.to_f / previous_count.to_f
  end
end
