# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactInformationController, type: :controller do
  let(:step) { assigns(:step) }
  before { session[:snap_application_id] = current_app.id }

  describe "#edit" do
    it "assigns the correct step" do
      get :edit

      expect(step).to be_an_instance_of ContactInformation
    end

    it "assigns the fields to the step" do
      get :edit

      expect(step.phone_number).to eq "11122233333"
      expect(step.email).to eq("test@example.com")
    end
  end

  describe "#update" do
    context "when valid" do
      it "updates the app" do
        valid_params = {
          phone_number: "11122233333",
          sms_subscribed: true,
          email: "test@example.com",
        }

        put :update, params: { step: valid_params }

        current_app.reload

        valid_params.each do |key, value|
          expect(current_app[key]).to eq(value)
        end
      end

      it "redirects to the next step" do
        valid_params = {
          phone_number: "1112223333",
          sms_subscribed: "false",
        }

        put :update, params: { step: valid_params }

        expect(response).to redirect_to("/steps/address")
      end
    end

    it "renders edit if the step is invalid" do
      put :update, params: { step: { phone_number: "" } }

      expect(assigns(:step)).to be_an_instance_of(ContactInformation)
      expect(response).to render_template(:edit)
    end
  end

  def current_app
    @_current_app ||= FactoryGirl.create(
      :snap_application,
      phone_number: "11122233333",
      email: "test@example.com",
    )
  end
end
