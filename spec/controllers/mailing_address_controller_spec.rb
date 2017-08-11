# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailingAddressController, type: :controller do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { zip: "11111111111" } } }
  let(:step_class) { MailingAddress }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.street_address).to eq("123 Fake St")
      expect(step.city).to eq("Springfield")
      expect(step.zip).to eq("12345")
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

        mailing_same_as_residential = {
          mailing_address_same_as_residential_address: "true",
        }

        put :update, params: { step: valid_params.merge(mailing_same_as_residential) }

        current_app.reload

        valid_params.each do |key, value|
          expect(current_app_mailing_address[key]).to eq(value)
        end

        expect(current_app.mailing_address_same_as_residential_address).to be true
      end

      it "always sets the county to 'Genesee' and state to 'MI'" do
        current_app_mailing_address.update(state: "CA", county: "test")
        valid_params = {
          street_address: "321 Main St",
          city: "Plymouth",
          zip: "48170",
          mailing_address_same_as_residential_address: true,
        }

        put :update, params: { step: valid_params }

        current_app_mailing_address.reload

        expect(current_app_mailing_address["county"]).to eq("Genesee")
        expect(current_app_mailing_address["state"]).to eq("MI")
      end

      it "redirects to the next step" do
        valid_params = {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          mailing_address_same_as_residential_address: true,
        }

        put :update, params: { step: valid_params }

        expect(response).to redirect_to("/steps/residential-address")
      end
    end
  end

  def current_app_mailing_address
    current_app.addresses.where(mailing: true).first
  end

  def current_app
    @_current_app ||= create(:snap_application, addresses: [address])
  end

  def address
    create(
      :address,
      street_address: "123 Fake St",
      city: "Springfield",
      zip: "12345",
      mailing: true,
    )
  end
end
