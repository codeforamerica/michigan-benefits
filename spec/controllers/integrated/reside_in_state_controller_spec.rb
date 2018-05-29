require "rails_helper"

RSpec.describe Integrated::ResideInStateController do
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

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            resides_in_state: "true",
          },
        }
      end

      it "updates navigator with attribute" do
        navigator = create(:application_navigator, resides_in_state: false)
        current_app = create(:common_application, navigator: navigator)
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        navigator = current_app.navigator.reload
        expect(navigator.resides_in_state?).to eq(true)
      end
    end
  end
end
