require "rails_helper"

RSpec.describe Integrated::PropertyController do
  describe "edit" do
    it "assigns existing property types" do
      current_app = create(:common_application, properties: ["house"])

      session[:current_application_id] = current_app.id

      get :edit

      expect(assigns[:form].properties).to match_array(["house"])
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          properties: ["house", ""],
        }
      end

      it "creates properties from params" do
        current_app = create(:common_application, properties: ["rental"])
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.properties).to match_array(["house"])
      end
    end
  end
end
