require "rails_helper"

RSpec.describe FeedbackForm do
  describe "validations" do
    it "is invalid without feedback rating or comments" do
      form = FeedbackForm.new

      expect(form).not_to be_valid
      expect(form.errors[:feedback_rating]).to be_present
    end

    it "is valid with feedback rating" do
      form = FeedbackForm.new(feedback_rating: "positive")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end

    it "is valid with feedback comments" do
      form = FeedbackForm.new(feedback_comments: "best application ever")

      expect(form).to be_valid
      expect(form.errors[:feedback_rating]).to_not be_present
    end
  end
end
