require "rails_helper"

RSpec.describe StepsController do
  context "when no applications have been started" do
    it "redirects to the homepage on a GET" do
      get :index

      expect(response).to redirect_to(root_path)
    end

    it "redirects to the homepage on a PUT" do
      put :update, params: { id: "" }

      expect(response).to redirect_to(root_path)
    end
  end

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
          MiBridges::Errors::StepNotFoundError,
          /Step not found: SomeRandom/,
        )
      end
    end
  end
end
