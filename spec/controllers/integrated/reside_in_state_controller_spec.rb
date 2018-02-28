require "rails_helper"

RSpec.describe Integrated::ResideInStateController do
  describe "update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            resides_in_state: "true",
          },
        }
      end

      context "when navigator does not yet exist" do
        it "creates navigator with correct attributes" do
          current_app = create(:common_application)
          session[:current_application_id] = current_app.id

          put :update, params: valid_params

          navigator = current_app.navigator.reload
          expect(navigator.resides_in_state?).to eq(true)
        end
      end

      context "when navigator already exists" do
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
end
