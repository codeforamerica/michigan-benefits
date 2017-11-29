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
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
          unstable_housing: "1",
        }

        put :update, params: { step: valid_params }

        residential_address.reload

        expect(residential_address.street_address).to eq("321 Real St")
        expect(residential_address.street_address_2).to eq("Apt 4")
        expect(residential_address.city).to eq("Shelbyville")
        expect(residential_address.zip).to eq("54321")
        expect(current_app.reload.stable_housing).to eq false
      end

      it "sets the county based on address" do
        valid_params = {
          street_address: "321 Main St",
          city: "Plymouth",
          zip: "48170",
        }

        county_finder = instance_double(CountyFinder)
        expect(CountyFinder).to receive(:new).with(
          street_address: "321 Main St",
          city: "Plymouth",
          zip: "48170",
          state: "MI",
        ).and_return(county_finder)
        allow(county_finder).to receive(:run).and_return("Wayne")

        put :update, params: { step: valid_params }

        residential_address.reload

        expect(residential_address.county).to eq("Wayne")
      end

      it "sets the state to 'MI'" do
        residential_address.update(state: "MA")
        valid_params = {
          street_address: "321 Main St",
          city: "Plymouth",
          zip: "48170",
        }

        put :update, params: { step: valid_params }

        residential_address.reload

        expect(residential_address.state).to eq("MI")
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

  def residential_address
    current_app.addresses.where(mailing: false).first
  end

  def address
    build(
      :residential_address,
      street_address: "I live here",
      city: "Hometown",
      zip: "54321",
    )
  end
end
