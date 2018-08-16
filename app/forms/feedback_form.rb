class FeedbackForm < Form
  set_attributes_for :application, :feedback_rating, :feedback_comments

  validates_presence_of :feedback_rating
end
