class FeedbackRatingsCalculator
  def initialize(applications)
    @applications = applications
  end

  def percentage(category)
    apps_of_type = applications.where(feedback_rating: category)
    apps_with_feedback = applications.where.not(feedback_rating: "unfilled")

    ((apps_of_type.count.to_f / apps_with_feedback.count.to_f) * 100).round unless applications.empty?
  end

  def net_satisfaction_score(positive_value: "positive", negative_value: "negative")
    percentage(positive_value) - percentage(negative_value) unless applications.empty?
  end

  private

  attr_reader :applications
end
