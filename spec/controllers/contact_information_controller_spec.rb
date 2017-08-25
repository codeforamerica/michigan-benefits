# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactInformationController, type: :controller do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { phone_number: "" } } }
  let(:step_class) { ContactInformation }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller", "param validation"

  describe "#edit" do
    it "assigns the fields to the step" do
      get :edit

      expect(step.phone_number).to eq "11122233333"
      expect(step.email).to eq("test@example.com")
    end
  end

  describe "#update" do
    context "when valid" do
      it "redirects to the next step" do
        valid_params = {
          phone_number: "2222222222",
          sms_subscribed: "false",
        }

        put :update, params: { step: valid_params }

        expect(response).to redirect_to("/steps/mailing-address")
      end
    end
  end

  def current_app
    @_current_app ||= create(
      :snap_application,
      phone_number: "11122233333",
      email: "test@example.com",
    )
  end
end
