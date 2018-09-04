class FeedbackRatingsCalculator
  def initialize(applications)
    @apps_with_feedback = applications.where.not(feedback_rating: "unfilled")
  end

  def percentage(category)
    apps_of_type = apps_with_feedback.where(feedback_rating: category)

    ((apps_of_type.count.to_f / apps_with_feedback.count.to_f) * 100).round unless apps_with_feedback.empty?
  end

  def net_satisfaction_score(positive_value: "positive", negative_value: "negative")
    percentage(positive_value) - percentage(negative_value) unless apps_with_feedback.empty?
  end

  private

  attr_reader :apps_with_feedback
end
