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

      context "when there is no current application" do
        it "does not process the request" do
          post :create, xhr: true, params: { feedback_form: valid_params }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when there is a current application" do
        it "updates the application" do
          current_app = create(:common_application, :with_navigator)
          session[:current_application_id] = current_app.id

          post :create, xhr: true, params: { feedback_form: valid_params }

          current_app.reload

          expect(response).to have_http_status(:created)
          expect(current_app.feedback_rating).to eq("neutral")
          expect(current_app.feedback_comments).to eq("My comments")
        end
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
        expect(response).to have_http_status(:unprocessable_entity)
        expect(current_app.feedback_rating).to eq("unfilled")
      end
    end
  end
end
