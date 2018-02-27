require "rails_helper"

RSpec.describe Integrated::BeforeYouStartController do
  describe "edit" do
    context "with a current application" do
      it "clears current application from session" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        expect(session[:current_application_id]).to be_nil
      end
    end

    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
      end
    end
  end
end
