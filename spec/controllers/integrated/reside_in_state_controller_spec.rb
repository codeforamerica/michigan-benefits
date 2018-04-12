require "rails_helper"

RSpec.describe Integrated::ResideInStateController do
  describe "#edit" do
    context "without a current application" do
      it "renders edit" do
        get :edit

        expect(response).to render_template(:edit)
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

      context "when application and navigator do not yet exist" do
        it "creates them and sets attribute on navigator" do
          put :update, params: valid_params

          current_app = CommonApplication.find(session[:current_application_id])
          expect(current_app.navigator.resides_in_state?).to eq(true)
        end
      end

      context "when application and navigator already exist" do
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
