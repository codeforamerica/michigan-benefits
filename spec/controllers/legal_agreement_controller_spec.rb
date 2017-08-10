# frozen_string_literal: true

require "rails_helper"

RSpec.describe LegalAgreementController do
  let(:step) { assigns(:step) }
  let(:invalid_params) { { step: { consent_to_terms: "false" } } }
  let(:step_class) { LegalAgreement }

  before { session[:snap_application_id] = current_app.id }

  include_examples "step controller"

  describe "#edit" do
    it "assigns the attributes to the step" do
      get :edit

      expect(attributes.keys.map { |attr| [attr, step.send(attr)] }.to_h).to eq attributes
    end
  end

  describe "#update" do
    context "consent to terms is true" do
      it "is valid" do
        params = { consent_to_terms: "true" }

        put :update, params: { step: params }

        expect(response).to redirect_to("/steps/sign-and-submit")
      end
    end
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end

  def attributes
    { consent_to_terms: true }
  end
end
