# frozen_string_literal: true

require "rails_helper"

RSpec.describe IntroductionContactInformationController, :member, type: :controller do
  let!(:current_app) do
    MbSnapApp.create!(
      user: member,
      street_address: "123 Fake St",
      city: "Springfield",
      county: "Genesee",
      zip: "12345",
      state: "MI",
    )
  end

  let(:step) { assigns(:step) }

  describe "#edit" do
    it "assigns the correct step" do
      get :edit
      expect(step).to be_an_instance_of IntroductionContactInformation
    end

    it "assigns the fields to the step" do
      get :edit
      expect(step.street_address).to eq("123 Fake St")
      expect(step.city).to eq("Springfield")
      expect(step.county).to eq("Genesee")
      expect(step.zip).to eq("12345")
      expect(step.state).to eq("MI")
    end
  end

  describe "#update" do
    context "when valid" do
      let(:valid_params) do
        {
          street_address: "321 Real St",
          city: "Shelbyville",
          zip: "54321",
          county: "Genesee",
          state: "MI",
        }
      end

      it "updates the app" do
        put :update, params: { step: valid_params }

        current_app.reload

        valid_params.each do |key, value|
          expect(current_app[key]).to eq(value)
        end
      end

      it "redirects to the next step" do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to("/steps/sign-and-submit")
      end
    end

    it "renders edit if the step is invalid" do
      put :update, params: { step: { zip: "1111111111" } }

      expect(assigns(:step)).to be_an_instance_of(IntroductionContactInformation)
      expect(response).to render_template(:edit)
    end
  end
end
