# frozen_string_literal: true

require "rails_helper"

RSpec.describe SendApplicationController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { email: "" } } }
  let(:step_class) { SendApplication }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(step.email).to eq "test@example.com"
    end
  end

  describe "#update" do
    it "redirects" do
      params = { step: attributes }

      put :update, params: params

      expect(response).to redirect_to(root_path(anchor: "fold"))
    end

    context "email entered" do
      it "updates attributes" do
        params = { step: { email: "new_email@example.com" } }

        expect do
          put :update, params: params
        end.to change {
          current_app.reload.email
        }.from("test@example.com").to("new_email@example.com")
      end

      it "creates a SendApplicationJob" do
        allow(SendApplicationJob).to receive(:perform_later).with(snap_application: current_app)
        params = { step: { email: "new_email@example.com" } }

        put :update, params: params

        expect(SendApplicationJob).to have_received(:perform_later).with(snap_application: current_app)
      end
    end
  end

  def attributes
    { email: "test@example.com" }
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end
end
