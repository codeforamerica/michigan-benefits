require "rails_helper"

RSpec.describe MailingAddressController, type: :controller do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { zip: "11111111111" } } }
  let(:step_class) { MailingAddress }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.street_address).to eq("123 Fake St")
      expect(step.city).to eq("Springfield")
      expect(step.zip).to eq("12345")
      expect(step.mailing_address_same_as_residential_address).to eq(true)
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the app with posted params" do
        params = {
          street_address: "321 Real St",
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
          mailing_address_same_as_residential_address: "false",
        }

        put :update, params: { step: params }

        mailing_address = current_app.reload.mailing_address

        expect(mailing_address.street_address).to eq("321 Real St")
        expect(mailing_address.street_address_2).to eq("Apt 4")
        expect(mailing_address.city).to eq("Shelbyville")
        expect(mailing_address.zip).to eq("54321")

        expect(current_app.mailing_address_same_as_residential_address).to be(
          false,
        )
      end

      it "sets the county based on address" do
        params = {
          street_address: "321 Real St",
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
          mailing_address_same_as_residential_address: "false",
        }

        county_finder = instance_double(CountyFinder)
        expect(CountyFinder).to receive(:new).with(
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          state: "MI",
        ).and_return(county_finder)
        allow(county_finder).to receive(:run).and_return("Wayne")

        put :update, params: { step: params }

        mailing_address = current_app.reload.mailing_address

        expect(mailing_address.county).to eq("Wayne")
      end

      it "sets the state to 'MI'" do
        params = {
          street_address: "321 Real St",
          street_address_2: "Apt 4",
          city: "Shelbyville",
          zip: "54321",
          mailing_address_same_as_residential_address: "false",
        }

        put :update, params: { step: params }

        mailing_address = current_app.reload.mailing_address

        expect(mailing_address.state).to eq("MI")
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

  def current_app
    @_current_app ||= create(
      :snap_application,
      mailing_address_same_as_residential_address: true,
      addresses: [address],
    )
  end

  def address
    build(
      :mailing_address,
      street_address: "123 Fake St",
      city: "Springfield",
      zip: "12345",
    )
  end
end
