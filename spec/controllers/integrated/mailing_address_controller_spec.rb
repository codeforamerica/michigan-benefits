require "rails_helper"

RSpec.describe Integrated::MailingAddressController do
  describe "#skip?" do
    context "when applicant has stable housing and the residential and mailing address are the same" do
      it "returns true" do
        application = create(:common_application,
                             living_situation: "stable_address",
                             navigator: build(:application_navigator, residential_mailing_same: true))

        skip_step = Integrated::MailingAddressController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#update" do
    context "with valid params" do
      let(:valid_params) do
        {
          street_address: "123 Main St",
          city: "Flint",
          zip: "48480",
        }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        expect(current_app.mailing_address.street_address).to eq("123 Main St")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        { street_address: "123 Main St" }
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
