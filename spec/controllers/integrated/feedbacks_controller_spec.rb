require "rails_helper"

RSpec.describe FeedbacksController do
  describe "#create" do
    context "with valid params" do
      let(:valid_params) do
        {
          feedback_rating: "neutral",
          feedback_comments: "My comments",
        }
      end

      it "updates the application" do
        current_app = create(:common_application, :with_navigator)
        session[:current_application_id] = current_app.id

        post :create, xhr: true, params: { feedback_form: valid_params }

        current_app.reload

        expect(current_app.feedback_rating).to eq("neutral")
        expect(current_app.feedback_comments).to eq("My comments")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          feedback_rating: "",
        }
      end

      it "does not process the request" do
        current_app = create(:common_application, :with_navigator)
        session[:current_application_id] = current_app.id

        post :create, xhr: true, params: { feedback_form: invalid_params }

        current_app.reload
        expect(current_app.feedback_rating).to eq("unfilled")
      end
    end
  end
end
