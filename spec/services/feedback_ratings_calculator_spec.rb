require "rails_helper"

RSpec.describe FeedbackRatingsCalculator do
  describe ".percentage" do
    context "when applications passed" do
      it "returns percentage of feedbacks left, as rounded percentage" do
        create_list(:common_application, 2, feedback_rating: "neutral")
        create(:common_application, feedback_rating: "positive")
        create(:common_application)

        calc = FeedbackRatingsCalculator.new(CommonApplication.all)

        expect(calc.percentage("neutral")).to eq(67)
      end
    end

    context "when no applications passed" do
      it "returns nil" do
        calc = FeedbackRatingsCalculator.new(CommonApplication.all)

        expect(calc.percentage("neutral")).to be_nil
      end
    end
  end

  describe ".net_satisfaction_score" do
    context "when applications passed" do
      it "returns happy percentage minus sad percentage, rounded" do
        create_list(:common_application, 2, feedback_rating: "positive")
        create(:common_application, feedback_rating: "negative")
        create(:common_application)

        calc = FeedbackRatingsCalculator.new(CommonApplication.all)

        expect(calc.net_satisfaction_score).to eq(34)
      end
    end

    context "when no applications passed" do
      it "returns nil" do
        calc = FeedbackRatingsCalculator.new(CommonApplication.all)

        expect(calc.net_satisfaction_score).to be_nil
      end
    end
  end
end
