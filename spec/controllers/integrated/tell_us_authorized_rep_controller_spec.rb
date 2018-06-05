require "rails_helper"

RSpec.describe Integrated::TellUsAuthorizedRepController do
  describe "#skip?" do
    context "no authorized representative designated" do
      it "returns true" do
        application = create(:common_application,
                             members: build_list(:household_member, 2, requesting_food: "yes"),
                             authorized_representative: "no")

        skip_step = Integrated::TellUsAuthorizedRepController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          authorized_representative_name: "Trusty McTrusterson",
          authorized_representative_phone: "2024561111",
        }
      end

      it "updates the model" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.authorized_representative_name).to eq("Trusty McTrusterson")
        expect(current_app.authorized_representative_phone).to eq("2024561111")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          authorized_representative_name: "Trusty McTrusterson",
          authorized_representative_phone: "6j7",
        }
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
