require "rails_helper"

RSpec.describe StepsController do
  context "when a snap application has been started" do
    it "renders the index page" do
      current_app = create(:snap_application)
      session[:snap_application_id] = current_app.id

      get :index

      expect(response).to render_template(:index)
    end
  end

  context "when a medicaid application has been started" do
    it "renders the index page" do
      current_app = create(:medicaid_application)
      session[:medicaid_application_id] = current_app.id

      get :index

      expect(response).to render_template(:index)
    end
  end

  context "no current application" do
    it "redirects to the root path" do
      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  describe ".step_class" do
    context "when step exists" do
      it "returns the correct step class" do
        expect(StepsController.step_class).to eq Step
      end
    end

    context "when step does not exist" do
      it "fails with a descriptive error message" do
        class SomeRandomController < StepsController; end

        expect { SomeRandomController.step_class }.to raise_error(
          StepsController::StepNotFoundError,
          /Step not found: SomeRandom/,
        )
      end
    end
  end
end
