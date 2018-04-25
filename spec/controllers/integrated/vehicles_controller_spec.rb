require "rails_helper"

RSpec.describe Integrated::VehiclesController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          own_vehicles: "true",
        }
      end

      it "updates the navigator" do
        current_app = create(:common_application,
          navigator: build(:application_navigator, own_vehicles: false))
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.own_vehicles?).to be_truthy
      end
    end
  end
end
