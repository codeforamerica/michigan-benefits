require "rails_helper"

RSpec.describe Integrated::LivingSituationController do
  describe "update" do
    context "with valid params" do
      let(:valid_params) do
        {
          form: {
            living_situation: "temporary_address",
          },
        }
      end

      it "saves the living_situation" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: valid_params

        current_app.reload
        expect(current_app.living_situation).to eq("temporary_address")
      end
    end
  end
end
