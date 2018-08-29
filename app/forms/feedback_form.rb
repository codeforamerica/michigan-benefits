class FeedbackForm < Form
  set_attributes_for :application, :feedback_rating, :feedback_comments

  validate :feedback_entered

  def feedback_entered
    return true if feedback_rating.present? || feedback_comments.present?
    errors.add(:feedback_rating, "Please select a rating or enter a comment.")
  end
end
