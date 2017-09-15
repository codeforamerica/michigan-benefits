require "rails_helper"

RSpec.describe ResidentialAddressController, type: :controller do
  let(:step) { assigns(:step) }
  let(:step_class) { ResidentialAddress }
  let(:invalid_params) do
    {
      step: {
        zip: "11111111111",
        unstable_housing: "0",
      },
    }
  end

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.street_address).to eq("I live here")
      expect(step.city).to eq("Hometown")
      expect(step.zip).to eq("54321")
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the app" do
        valid_params = {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
        }

        unstable_housing = { unstable_housing: "1" }

        put :update, params: { step: valid_params.merge(unstable_housing) }

        current_app_residential_address.reload

        valid_params.each do |key, value|
          expect(current_app_residential_address[key]).to eq(value)
        end

        expect(current_app.reload.unstable_housing).to be true
      end

      it "always sets the county to 'Genesee' and state to 'MI'" do
        current_app_residential_address.update(state: "MA", county: "example")
        valid_params = {
          street_address: "321 Main St",
          city: "Plymouth",
          zip: "48170",
        }

        put :update, params: { step: valid_params }

        current_app_residential_address.reload

        expect(current_app_residential_address["county"]).to eq("Genesee")
        expect(current_app_residential_address["state"]).to eq("MI")
      end

      it "redirects to the next step" do
        valid_params = {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          unstable_housing: "1",
        }

        put :update, params: { step: valid_params }

        expect(response).to redirect_to("/steps/introduction-complete")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, addresses: [address])
  end

  def current_app_residential_address
    current_app.addresses.where.not(mailing: true).first
  end

  def address
    create(
      :address,
      street_address: "I live here",
      city: "Hometown",
      zip: "54321",
      mailing: false,
    )
  end
end
