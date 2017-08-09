# frozen_string_literal: true

require "rails_helper"

RSpec.describe LegalAgreementController do
  before do
    session[:snap_application_id] = current_app.id
  end

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

    context "consent to terms is false" do
      it "is invalid" do
        params = { consent_to_terms: "false" }

        put :update, params: { step: params }

        expect(assigns(:step)).to be_an_instance_of(LegalAgreement)
        expect(response).to render_template(:edit)
      end
    end
  end

  def attributes
    { consent_to_terms: true }
  end

  def step
    @_step ||= assigns(:step)
  end

  def current_app
    @_current_app ||= create(:snap_application, attributes)
  end
end
