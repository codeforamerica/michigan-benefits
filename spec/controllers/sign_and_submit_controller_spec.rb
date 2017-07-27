# frozen_string_literal: true

require "rails_helper"

RSpec.describe SignAndSubmitController do
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
    it "updates attributes" do
      params = { step: { signature: "Chiu Baka" } }

      expect do
        put :update, params: params
      end.to change {
        current_app.reload.signature
      }.from("Hans Solo").to("Chiu Baka")
    end

    it "redirects" do
      params = { step: { signature: "Chiu Baka" } }

      put :update, params: params

      expect(response).to redirect_to("/steps/send-application")
    end
  end

  def step
    @_step ||= assigns(:step)
  end

  def current_app
    @_current_app ||= FactoryGirl.create(:snap_application, attributes)
  end

  def attributes
    { signature: "Hans Solo" }
  end
end
