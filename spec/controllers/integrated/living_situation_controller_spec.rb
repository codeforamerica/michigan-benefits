require "rails_helper"

RSpec.describe Integrated::LivingSituationController do
  describe "#edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application, living_situation: "stable_address")
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)

        expect(form.living_situation).to eq("stable_address")
      end
    end
  end

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
