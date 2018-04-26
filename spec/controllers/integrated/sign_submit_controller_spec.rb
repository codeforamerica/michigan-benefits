require "rails_helper"

RSpec.describe Integrated::SignSubmitController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { signature: "Jane Hancock " }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.signature).to eq("Jane Hancock")
        expect(current_app.signed_at).to_not be_nil
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { signature: "" }
      end

      it "renders edit without updating" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
