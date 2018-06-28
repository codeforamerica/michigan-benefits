require "rails_helper"

RSpec.describe Integrated::LegalAgreementController do
  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        { agree_to_terms: true }
      end

      it "updates the models" do
        current_app = create(:common_application, :with_navigator)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.navigator.agree_to_terms).to be_truthy
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { agree_to_terms: "" }
      end

      it "renders edit without updating" do
        current_app = create(:common_application, :with_navigator)
        session[:current_application_id] = current_app.id

        put :update, params: { form: invalid_params }

        expect(response).to render_template(:edit)
      end
    end
  end
end
