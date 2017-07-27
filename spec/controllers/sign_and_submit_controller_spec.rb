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

      expect(response).to redirect_to root_path(anchor: "fold")
    end

    it "creates a PDF with the data" do
      app = current_app
      data = {
        applying_for_food_assistance: "Yes",
        full_name: app.name,
        birth_day: app.birthday.strftime("%d"),
        birth_month: app.birthday.strftime("%m"),
        birth_year: app.birthday.strftime("%Y"),
        street_address: app.street_address,
        city: app.city,
        county: app.county,
        state: app.state,
        zip: app.zip,
        signature: "Mr. RJD2",
        signature_date: app.signed_at,
      }

      pdf_double = double(save: true)
      allow(Dhs1171Pdf).to receive(:new).with(data).and_return(pdf_double)

      put :update, params: { step: { signature: "Mr. RJD2" } }

      expect(pdf_double).to have_received(:save)
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
