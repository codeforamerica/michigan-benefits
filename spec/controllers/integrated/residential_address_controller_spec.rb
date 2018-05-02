require "rails_helper"

RSpec.describe Integrated::ResidentialAddressController do
  describe "#skip?" do
    context "when applicant does not have stable housing" do
      it "returns true" do
        application = create(:common_application, living_situation: "homeless")

        skip_step = Integrated::ResidentialAddressController.skip?(application)
        expect(skip_step).to eq(true)
      end
    end
  end

  describe "#edit" do
    context "with a current application" do
      it "assigns existing attributes" do
        current_app = create(:common_application,
                             navigator: build(:application_navigator, residential_mailing_same: true))
        current_app.create_residential_address(
          street_address: "123 Main St",
          city: "Flint",
          state: "MI",
          county: "Genesee",
          zip: "48480",
        )
        session[:current_application_id] = current_app.id

        get :edit

        form = assigns(:form)
        expect(form.street_address).to eq("123 Main St")
        expect(form.zip).to eq("48480")
        expect(form.residential_mailing_same).to be_truthy
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
          residential_mailing_same: "true",
        }
      end

      it "updates the models" do
        current_app = create(:common_application)
        session[:current_application_id] = current_app.id

        put :update, params: { form: valid_params }

        current_app.reload

        # expectation
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
