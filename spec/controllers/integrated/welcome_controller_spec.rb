require "rails_helper"

RSpec.describe Integrated::WelcomeController do
  describe "#skip?" do
    it "returns false" do
      application = create(:common_application)

      skip_step = Integrated::WhichProgramsController.skip?(application)
      expect(skip_step).to eq(false)
    end
  end

  describe "#edit" do
    context "with a current application" do
      it "renders edit" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        get :edit

        expect(response).to render_template(:edit)
      end
    end

    context "without a current application" do
      it "redirects to home" do
        get :edit

        expect(response).to redirect_to(controller.first_step_path)
      end
    end
  end
end
