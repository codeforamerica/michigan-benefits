require "rails_helper"

RSpec.describe FeedbackForm do
  describe "validations" do
    it "requires feedback_rating" do
      form = FeedbackForm.new

      expect(form).not_to be_valid
      expect(form.errors[:feedback_rating]).to be_present
    end
  end
end
