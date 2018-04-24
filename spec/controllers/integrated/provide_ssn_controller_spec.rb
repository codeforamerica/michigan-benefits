require "rails_helper"

RSpec.describe Integrated::ProvideSsnController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { ssn: "123456789" }
      end

      it "updates the models" do
        current_app = create(:common_application, :single_member)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.primary_member.ssn).to eq("123456789")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { ssn: "1234" }
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
