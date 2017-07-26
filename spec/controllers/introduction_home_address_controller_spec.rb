# frozen_string_literal: true

require "rails_helper"

RSpec.describe IntroductionHomeAddressController, :member, type: :controller do
  let(:params) do
    {
      home_address: "123 Fake St",
      home_city: "Springfield",
      home_zip: "12345",
      unstable_housing: false,
    }
  end

  let!(:current_app) do
    App.create!(user: member, **params)
  end

  let(:step) { assigns(:step) }

  describe "#edit" do
    pending "assigns the correct step" do
      get :edit
      expect(step).to be_an_instance_of IntroductionHomeAddress
    end

    pending "assigns the fields to the step" do
      get :edit
      params.each do |key, value|
        expect(step.send(key)).to eq(value)
      end
    end

    pending "is skipped if the mailing address is the same as the home address" do
      current_app.update!(mailing_address_same_as_home_address: true)
      get :edit
      expect(response).to be_redirect
    end
  end

  describe "#update" do
    context "when valid" do
      let(:valid_params) do
        {
          home_address: "321 Real St",
          home_city: "Shelbyville",
          home_zip: "54321",
          unstable_housing: true,
        }
      end

      pending "updates the app" do
        put :update, params: { step: valid_params }

        current_app.reload

        valid_params.each do |key, value|
          expect(current_app[key]).to eq(value)
        end
      end

      pending "redirects to the next step" do
        put :update, params: { step: valid_params }

        expect(response).to redirect_to(step_path("introduction-complete"))
      end
    end

    pending "renders edpending if the step is invalid" do
      put :update, params: { step: { home_address: "1111111111" } }

      expect(assigns(:step)).to be_an_instance_of(IntroductionHomeAddress)
      expect(response).to render_template(:edit)
    end
  end
end
